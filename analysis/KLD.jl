using Distributions
using Random
using DataFrames
using CSV
include("./polya.jl")
using .Polya
using ArgParse

function string_to_symbols(s::String)
    return Symbol.(split(s, ","))
end

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--index"
            help = "Column names to index each input row, separated by comma"
            required = true
        "--by"
            help = "Column names to index each output row, separated by comma"
            required = true
        "input_file"
            help = "Input file to read"
            required = true
        "output_file"
            help = "Output file to write"
            required = true
    end

    return parse_args(s)
end

function compute_KLD(share::Array{Float64,N}, p::Vector{Float64}) where {N}
    all(sum(share, dims=1) .≈ 1) || throw(ArgumentError("Shares have to sum to 1.")) 
    deviation = log.(share ./ p)
    # log(0) is fine because 0*log(0) = 0
    replace!(deviation, -Inf=>0)
    # convert to vector instead of 1xK array
    return sum(share .* deviation, dims=1)
end

function compute_p_values(A; debug=false)
    # countries with positive shipments
    non_empty_columns = vec(sum(A, dims=1) .> 0)
    # exclude empty rows
    data = A[vec(sum(A, dims=2) .> 0), non_empty_columns]
    K, N = size(data)

    if debug
        println(size(A))
        println(size(data))
        println(non_empty_columns)
    end

    # if no data left, return p = 1.0 because we cannot reject the null
    # cannot estimate countries where all shipments go to the same bin
    (K > 1 && N > 1) || return ones(Float64, N), non_empty_columns

    H0_params = Polya.mle(DirichletMultinomial, data, tol=1e-4)
    H0_shares = H0_params.α ./ sum(H0_params.α)
    actual_KLD = compute_KLD(data ./ sum(data, dims=1), H0_shares)
    
    p = zeros(Float64, N)
    for i = 1:N
        # actual number of shipments treated as a parameter
        H1 = DirichletMultinomial(sum(data[:,i]), H0_params.α)
        pmf = Polya.simulate_ECDF(H1, 
            x -> compute_KLD(x ./ sum(x, dims=1), 
                    H0_params.α ./ H0_params.α0), 
            maxiter=10000, digits=3)
        p[i] = 1 - cdf(pmf, actual_KLD[1,i])
    end
    # return the p vector and an index of where to put it
    return p, non_empty_columns
end

function flip(A::Array) :: Array
    return Array(A')
end

function main(input_file::String, output_file::String, input_index::Array{Symbol,1}, by_index::Array{Symbol,1})
    data = DataFrame(CSV.File(input_file))

    header = Array(data[:,1:2])
    input = Array(data[:,3:end])
    output = ones(Float64, size(input, 1))

    Threads.@threads for row in eachrow(unique(data[:,1:1]))
        d = row[1]
        println(d)

        indexes = (header[:,1] .== d)
        subset = input[indexes, :]
        long_p_vector = ones(Float64, size(subset, 1))
        short_p_vector, non_empty_columns = compute_p_values(flip(subset), debug=false)
        # only use p values for countries with non-missing data, rest are 1.0
        long_p_vector[non_empty_columns] .= short_p_vector
        # round p-value to 4 digits
        output[indexes] .= round.(long_p_vector*1e4) / 1e4
    end

    df = DataFrame(origin=header[:,2], destination=header[:,1], p=output)
    CSV.write(output_file, df)
end

# call from the command line: "julia KLD.jl ../temp/shipment-clean.csv ../temp/p-values.csv"
parsed_args = parse_commandline()
input_file = parsed_args["input_file"]
output_file = parsed_args["output_file"]
input_index =string_to_symbols(parsed_args["index"])
by_index = string_to_symbols(parsed_args["by"])

main(input_file, output_file, input_index, by_index)

