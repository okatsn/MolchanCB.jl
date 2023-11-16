@testset "binomial.jl" begin
    function testtest(N)
        for n in N
            for h in rand(1:n-1, 5)
                @test binomial(n, h) == factorial(n) / (factorial(h) * factorial(n - h))

                p = collect(0:0.01:1)
                @test isequal(
                    MolchanCB.bidistributionmap(p, n, h),
                    MolchanCB.bidistribution.(p, n, h)
                )

            end
        end
    end

    testtest(2:20)
    testtest(big.([20, 50]))
end
