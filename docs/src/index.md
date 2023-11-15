```@meta
CurrentModule = MolchanCB
```

# MolchanCB

[MolchanCB](https://github.com/okatsn/MolchanCB.jl) contains the tools for calculating the confidence boundary on the Molchan plane [zecharTestingAlarmbasedEarthquake2008](@citep).



## Confidence boundary on the Molchan plane

Here is an example of using [`molchancb`](@ref) to reproduce [zecharTestingAlarmbasedEarthquake2008; Fig. 3 (a)](@citet):


```@example fig3

using CairoMakie, AlgebraOfGraphics
using MolchanCB
using DataFrames
using CategoricalArrays

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
for alpha = [0.01, 0.05, 0.25, 0.50]
    (al, ms) = molchancb(N, alpha)
    append!(df, createdata(;
        missing_rate=ms,
        alarm_rate=al,
        event_number=N,
        alpha=alpha
    ))
end


transform!(df, :α => CategoricalArray; renamecols=false)

data(df) * visual(Lines) * mapping(:τ, :ν) * mapping(color=:α) |> 
        plt -> draw(plt; axis=(; aspect=AxisAspect(1)))

```

, and [zecharTestingAlarmbasedEarthquake2008; Fig. 3 (b)](@citet):

```@example fig3

df = createdata()

alpha = 0.05
for N = [5, 15, 50, 100]
    (al, ms) = molchancb(big(N), alpha)
    append!(df, createdata(;
        missing_rate=ms,
        alarm_rate=al,
        event_number=N,
        alpha=alpha
    ))
end

transform!(df, :N => CategoricalArray; renamecols=false)


data(df) * visual(Lines) * mapping(:τ, :ν) * mapping(color=:N) |>
plt -> draw(plt; axis=(; aspect=AxisAspect(1)))


```


## Binomial Distribution

```@example
using CairoMakie, AlgebraOfGraphics
using MolchanCB
using DataFrames
using CategoricalArrays

df = DataFrame(
    :x => Float64[],
    :y => Float64[],
    :N => Int64[],
    :h => Int64[],
)

x = 0:0.001:1
hlist = [2, 4]

for N = 5:10
    for h in hlist 
        y = MolchanCB.bidistribution.(x, N, h)
        append!(df, DataFrame(
            :x => x, :y => y, :N => N, :h => h
        ))
    end
end

transform!(df, :N => CategoricalArray; renamecols=false)
transform!(df, :h => CategoricalArray; renamecols=false)

data(df) * visual(Lines) * mapping(:x, :y) * mapping(color=:N) * mapping(row=:h) |>
plt -> draw(plt; axis = (; title="Binomial distribution for h in $hlist"))

```

# Reference

```@bibliography
```


# Index


```@index
```

```@autodocs
Modules = [MolchanCB]
```

