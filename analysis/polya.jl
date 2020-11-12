module Polya
using Distributions
export estimate_dirichlet_multinomial, simulate_ECDF
export EmpiricalCDF, evaluate_CDF

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
    cdf = DirichletMultinomial(n, 2.0*ones(K))

    distance = 1e+12
        
    for iter in 1:maxiter
        new_cdf = _iterate_dirichlet_multinomial_MLE(X, cdf)
        distance = maximum(abs.(log.(cdf.α) .- log.(new_cdf.α)))
        cdf = new_cdf
        # if already below tolerance, break out of loop
        distance < tol && break
    end
    
    return cdf
end

function simulate_ECDF(cdf::DirichletMultinomial, f::Function; maxiter::Int = 100000, digits::Int = 5) :: DiscreteNonParametric
    counts = rand(cdf, maxiter)
    p = cdf.α ./ sum(cdf.α)
    shares = counts ./ sum(counts, dims=1)
    y = round.(vec(f(shares, p)), digits=digits)
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


end