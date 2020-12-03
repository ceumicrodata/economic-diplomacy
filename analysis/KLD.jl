using Distributions
using Random
using DataFrames
using CSVFiles
include("./polya.jl")
using .Polya

function compute_KLD(share::Array{Float64,N}, p::Vector{Float64}) where {N}
    all(sum(share, dims=1) .≈ 1) || throw(ArgumentError("Shares have to sum to 1.")) 
    deviation = log.(share ./ p)
    # log(0) is fine because 0*log(0) = 0
    replace!(deviation, -Inf=>0)
    # convert to vector instead of 1xK array
    return sum(share .* deviation, dims=1)
end

function compute_p_values(A)
    # exclude empty rows
    data = A[vec(sum(A, dims=2) .> 0), :]
    K, N = size(data)
    
    # if no data left, return p = 1.0 because we cannot reject the null
    K > 0 || return ones(Float64, N)
    
    # countries with no shipments at all
    empty_columns = vec(sum(data, dims=1) .== 0)
    # add 1 shipment to these so that algorithm completes but change p = 1 later
    data[1, empty_columns] .= 1
    
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
    # we have no information to reject the null
    p[empty_columns] .= 1.0
    return p
end

data = DataFrame(load("../temp/shipment-clean.csv"))

function get_destination_matrix(data; country::String, year::Int = 2017)
    return filter(row -> row.iso2_d == country && row.year == year, data)[:,4:end-1]
end

function flip(A::Array) :: Array
    return Array(A')
end

years = unique(data.year)
destinations = unique(data.iso2_d)

header = Array(data[:,1:3])
input = Array(data[:,4:end])
output = zeros(Float64, size(input, 1))

Threads.@threads for d in destinations
    for t in years
        println(d, t)

        indexes = (header[:,2] .== d) .& (header[:,3] .== t)
        subset = input[indexes, :]
        p = compute_p_values(flip(subset))
        output[indexes] .= p
    end
end

df = DataFrame(iso2_o=header[:,1], iso2_d=header[:,2], year=header[:,3], p=output)
save("../temp/p-values.csv", df)


