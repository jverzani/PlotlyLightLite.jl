# PlotlyLightLite.jl

Documentation for [PlotlyLightLite](https://github.com/jverzani/PlotlyLightLite.jl), a package to give `Plots`-like access to `PlotlyLight` for the graphs of Calculus. Where:

* `Plotly` is a JavaScript library for plotting that is widely used an has interfaces for `Python`, `R`, and `Julia` (through `PlotlyJS`).
* `PlotlyLight` is a very lightweight package to create `Plotly` graphs using the JavaScript interface. The JSON structures are readily created using `Config` on the `Julia` side.
* `Plots.jl` is a popular package for plotting in `Julia` with numerous backends including `Plotly`.


This package provides a light-weight alternative to `Plots.jl` which utilizes basically a subset of the `Plots` interface. It is inspired by `SimplePlots` and is envisioned as being useful within resource-constrained environments such as [`binder.org`](https://mybinder.org/v2/gh/mth229/229-projects/lite?labpath=blank-notebook.ipynb).
