"""
`bidistribution(p, N, h)`, returns the probability of `h` hits in alarmed region A⊆R out of total `N` events, assuming a binomial distribution for whether hit the region of A or out of A.

- R is the region we wish to predict the target event.
- `p` is in `[0, 1]`.

Please refer to [zecharTestingAlarmbasedEarthquake2008; Eq. 2](@citet).
"""
bidistribution(p, N, h) = factorial(N) / (factorial(h) * factorial(N - h)) * (p^h) * ((1 - p)^(N - h))

"""
Probability of hitted `h` or more.

Please refer to [zecharTestingAlarmbasedEarthquake2008; Eq. 3](@citet).
"""
function probhmore(P̃_A, N, h)
    P_h_or_more = fill(0.0, length(P̃_A))

    for k in h:N
        P_h_or_more .+= bidistribution.(P̃_A, N, k)
    end

    return P_h_or_more
end


function molchancb(N; resolution=0.001, alpha=0.05)
    P̃_A = 0:resolution:1 # The probability-weighted area of alarmed region.

    alrate_cb = Float64[]
    msrate_cb = Float64[]
    for h = 1:N
        P_h_or_more = probhmore(P̃_A, N, h)
        approxid = findlast(P_h_or_more .<= alpha)
        push!(alrate_cb, P_h_or_more[approxid]) # confidence boundary of the alarm rate
        push!(msrate_cb, N - h / N) # confidence boundary of the missing rate
    end

    return (alrate_cb, msrate_cb)
end
