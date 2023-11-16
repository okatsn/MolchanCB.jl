# Performance hints:
# - https://stackoverflow.com/questions/37193586/bigints-seem-slow-in-julia
# - https://julialang.org/blog/2017/01/moredots/#other-partway-solutions
"""
`bidistribution(p, N, h)`, returns the probability of `h` hits in alarmed region A⊆R out of total `N` events, assuming a binomial distribution for whether hit the region of A or out of A.

``B(h|N, p) = \\frac{N!}{h! (N - h)!} (p^h) ((1 - p)^{N - h})``

- R is the region we wish to predict the target event.
- `p` is in `[0, 1]`.

Please refer to [zecharTestingAlarmbasedEarthquake2008; Eq. 2](@citet).
"""
bidistribution(p, N, h) = binomial(N, h) * (p^h) * ((1 - p)^(N - h))

bidistributionmap(p, N, h) = binomial(N, h) .* (p .^ h) .* ((1 .- p) .^ (N - h))

"""
Probability of hitted `h` or more.

``\\sum_{n=h}^{N}B(n|N,P̃_A)``.

`h` is the number of event that hit the alarmed area; please refer to [zecharTestingAlarmbasedEarthquake2008; Eq. 3](@citet).
"""
function probhmore(P̃_A, N, h)
    P_h_or_more = fill(0.0, length(P̃_A))

    for k in h:N
        P_h_or_more .+= bidistributionmap(P̃_A, N, k)
    end

    return P_h_or_more
end


"""
`molchancb(N, alpha; resolution=0.001)` returns a vector of alarm rate and a vector of missing rate;
they constitute the confidence boundary of `1-alpha` × 100%.

Use `N = big(N)` when encountering `OverflowError`.
"""
function molchancb(N, alpha; resolution=0.001)
    if isa(N, BigInt)
        resolution = BigFloat(resolution) # This brings 1.5 times speed up.
    end
    P̃_A = 0:resolution:1 # The probability-weighted area of alarmed region.

    alrate_cb = Float64[]
    msrate_cb = Float64[]
    for h = 1:N
        P_h_or_more = probhmore(P̃_A, N, h)
        approxid = findlast(P_h_or_more .<= alpha) # finding the minimum value of τ (i.e. alarmed rate) that solves the equality in Eq. 3 (Zechar 2008) for each discrete ν (i.e. missing rate).
        τ = P̃_A[approxid]
        ν = (N - h) / N
        push!(alrate_cb, τ) # confidence boundary of the alarm rate
        push!(msrate_cb, ν) # confidence boundary of the missing rate
    end

    return (alarm_rate=alrate_cb, missing_rate=msrate_cb)
end
