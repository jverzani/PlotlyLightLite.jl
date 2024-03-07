# PlotlyLightLite.jl

Documentation for [PlotlyLightLite](https://github.com/jverzani/PlotlyLightLite.jl), a package to give `Plots`-like access to `PlotlyLight` for the commonly used graphs of Calculus. Where:

* [Plotly](https://plotly.com/) is a JavaScript library for plotting that is widely used and has supported interfaces for `Python`, `R`, and `Julia` (through `PlotlyJS`).
* [PlotlyLight](https://github.com/JuliaComputing/PlotlyLight.jl) is a very lightweight package to create `Plotly` graphs using the JavaScript interface. The JSON structures are readily created using the clever `Config` constructor on the `Julia` side.
* [Plots.jl](https://github.com/JuliaPlots/Plots.jl) is a popular package for plotting in `Julia` with numerous backends including `Plotly`.


This package provides a light-weight alternative to `Plots.jl` utilizing a subset of the `Plots` interface, particularly where it allows a function to be specified in a declarative manner. It is inspired by `SimplePlots` and is envisioned as being useful within resource-constrained environments such as [`binder.org`](https://mybinder.org/v2/gh/mth229/229-projects/lite?labpath=blank-notebook.ipynb).

!!! note "A misnomer"
    The name is a bit of a misnomer; this package is actually "heavier" than `PlotlyLight` in terms of lines of code, but *much* lighter than plots so perhaps, `PlotsLitePlotlyLight` might have been a better...



## Installation

The package is not registered. It may be installed through `Pkg.add(url="..."))`.

Once installed, the package is loaded in the standard manner.

```@example lite
using PlotlyLightLite
using PlotlyDocumenter # hide
```

The package should load very quickly and the time to first plot should be quite speedy as this is the case for `PlotlyLight`.


## Saving figures

Saving figures is the same as with `PlotlyLight`.

To save a figure to HTML, we have:

```
PlotlyLightLite.PlotlyLight.save(p, "filename.html")
```

To save a figure to an image file, the `PlotlyKaleido` package is used:

```
using PlotlyKaleido
PlotlyKaleido.start()

(;data, layout, config) = p;
PlotlyKaleido.savefig((; data, layout, config), "myplot.png")
```
