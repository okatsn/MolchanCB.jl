@testset "binomial.jl" begin
    for N in 2:20
        for h in rand(1:N-1, 5)
            @test binomial(N, h) == factorial(N) / (factorial(h) * factorial(N - h))
        end
    end
end
