using MolchanCB
using Documenter

DocMeta.setdocmeta!(MolchanCB, :DocTestSetup, :(using MolchanCB); recursive=true)

makedocs(;
    modules=[MolchanCB],
    authors="okatsn <okatsn@gmail.com> and contributors",
    repo="https://github.com/okatsn/MolchanCB.jl/blob/{commit}{path}#{line}",
    sitename="MolchanCB.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://okatsn.github.io/MolchanCB.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/okatsn/MolchanCB.jl",
    devbranch="main",
)
