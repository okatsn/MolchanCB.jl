B(k) = factorial(N) / (factorial(k) * factorial(N - k)) * (molt .^ k) .* ((1 - molt) .^ (N - k));

function molchancb(N; resolution=0.001, alpha=0.05)
    P̃_A = 0:resolution:1 # The probability-weighted area of alarmed region.
    B = factorial(N)



end
