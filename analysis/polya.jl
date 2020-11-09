module Polya
using Distributions
export estimate_dirichlet_multinomial

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

end