using Documenter
using PlotlyLightLite

makedocs(
    modules = [PlotlyLightLite],
    authors="jverzani <jverzani@gmail.com> and contributors",
    repo="https://github.com/jverzani/PlotlyLightLite.jl/blob/{commit}{path}#{line}",
    sitename = "PlotlyLightLite.jl",
    format=Documenter.HTML(;
                           prettyurls=(get(ENV, "CI", "false") == "true"),
                           canonical="https://jverzani.github.io/PlotlyLightLite.jl",
                           edit_link="main",
                           assets=String[],
                           size_threshold_ignore = ["basic-graphics.md","three-d-graphics.md", "three-d-shapes.md"],
                           ),

    pages=[
        "Home" => "index.md",
        "Features" => [
            "Basics" => "basic-graphics.md",
            "3D graphics" => "three-d-graphics.md",
            "3D shapes" => "three-d-shapes.md"
        ],
        "Reference/API" => "reference.md",
    ],

)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/jverzani/PlotlyLightLite.jl.git",
)
