using CairoMakie, AlgebraOfGraphics
using MolchanCB
using DataFrames

createdata(;
    missing_rate=Float64[],
    alarm_rate=Float64[],
    event_number=Int64[],
    alpha=Float64[]
) = DataFrame(
    :ν => missing_rate,
    :τ => alarm_rate,
    :N => event_number,
    :α => alpha,
)

df = createdata()

N = 15
for alpha in [0.01, 0.05, 0.25, 0.50]
    N = 15
    (al, ms) = molchancb(N, alpha)
    append!(df, createdata(;
        missing_rate=ms,
        alarm_rate=al,
        event_number=N,
        alpha=alpha
    ))
end


f = AlgebraOfGraphics.data(df) * visual(Lines) * mapping(:τ, :ν) * mapping(color=:α) |> draw