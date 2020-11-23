module Polya
using Distributions
export estimate_dirichlet_multinomial, simulate_ECDF, gmm

function _iterate_dirichlet_multinomial_MLE(nki::Array{T,N}, cdf::DirichletMultinomial) where {T <: Integer,N}
    # first dimension is categories
    # other dimensions hold different samples from the distribution, organized in whatever order
    K = size(nki, 1)
    ndim = N
   
    ni = sum(nki, dims=1)
    n = sum(nki)
    
    # let α have the same dimension as the data
    dims = ones(Int, ndim)
    dims[1] = K
    αk = reshape(cdf.α, dims...)
    α0 = sum(αk, dims=1)
    
    # use eq (65) from https://tminka.github.io/papers/dirichlet/minka-dirichlet.pdf
    return DirichletMultinomial(n, 
        vec(αk .* sum(nki ./ (nki .+ αk .- 1), dims=2:ndim) ./ 
            sum(ni ./ (ni .+ α0 .- 1), dims=2:ndim)))
end

function estimate_dirichlet_multinomial(X::Array{T,N}; 
        tol::Float64 = 1e-8, maxiter::Int = 1000) where {T <: Integer,N}
    K = size(X, 1)
    n = sum(X)
    
    starting_value = 2.0 * K * sum(X, dims=2:N) ./ sum(X)
    cdf = DirichletMultinomial(n, vec(starting_value))

    for iter in 1:maxiter
        new_cdf = _iterate_dirichlet_multinomial_MLE(X, cdf)
        distance = maximum(abs.(log.(cdf.α) .- log.(new_cdf.α)))
        cdf = new_cdf
        # if already below tolerance, break out of loop
        distance < tol && break
    end
    
    return cdf
end

function simulate_ECDF(cdf::T, f::Function; maxiter::Int = 100000, digits::Int = 5) :: DiscreteNonParametric where T <: MultivariateDistribution
    
    x = rand(cdf, maxiter)
    y = round.(vec(f(x)), digits=digits)
    sort!(y)
    support = unique(y)
    CDF = zeros(length(support), 2)
    for (i, x) in enumerate(support)
        CDF[i, 1] = x
        CDF[i, 2] = findfirst(a -> a >= x, y)
    end
    pmf = diff(CDF[:,2], dims=1)
    pmf = [pmf; maxiter - last(CDF[:,2])]
    return DiscreteNonParametric(CDF[:,1], pmf ./ sum(pmf))
end

function simulate_mixture(prior::Dirichlet, ns::Vector{Int64}, f::Function; 
        maxiter::Int = 1000000, digits::Int = 5) :: DiscreteNonParametric
    K1 = Int64(floor(maxiter^0.5))
    K2 = Int64(ceil(maxiter / K1))
    
    ps = rand(prior, K1)

end
function gmm(::Type{DirichletMultinomial}, x::AbstractArray{T, N}) where {T<:Real, N}
    ns = sum(x, dims=1)
    shares = x ./ ns
        
    K = size(x, 1)
    weight = ns ./ sum(ns)
    
    # gmm from p7 of  https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2945396/pdf/nihms205488.pdf
    m = vec(sum(x, dims=2:N) ./ sum(x))
    # but use sample-weighted average instead
    rho = sum(sum(weight .* shares.^2, dims=2:N) ./ sum(weight .* shares, dims=2:N))
    precision = (K - rho) / (rho - 1) 
    
    return DirichletMultinomial(maximum(ns), 1 .+ precision .* m)
end

function mle(::Type{<:DirichletMultinomial}, x::Matrix{T};
                 tol::Float64 = 1e-8, maxiter::Int = 1000) where T <: Real
    K, N = size(x)
    ns = sum(x, dims=1)

    # initialize with GMM estimate
    α = Polya.gmm(DirichletMultinomial, x).α
    @inbounds for iter in 1:maxiter
        α_old = copy(α)
        αsum = sum(α)
        # use eq (3.5) of https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2945396/pdf/nihms205488.pdf
        denom = zeros(Float64, N)
        num = zeros(Float64, K, N)
        @inbounds for i = 1:N
            denom[i] = sum([1 / (αsum + k) for k=0:ns[i]-1])
            for j in eachindex(α)
                αj = α[j]
                num[j, i] = sum([1 / (αj + k) for k=0:x[j,i]-1])
            end
        end
        α = α .* sum(num, dims=2) ./ sum(denom)
        maximum(abs, α_old - α) < tol && break
    end
    DirichletMultinomial(maximum(ns), vec(α))
end


end