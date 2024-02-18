# Basics of PlotlyLightLite

The plotting interface provided picks some of the many parts of `Plots.jl` that prove useful for the graphics of calculus and provides a stripped-down, though reminiscent, interface using `PlotlyLight`, a package which otherwise is configured in a manner very-much like the underlying `JavaScript` implementation. The `Plots` package is great -- and has a `Plotly` backend -- but for resource-constrained usage can be too demanding.


Some principles of `Plots` are:

* The `Plots.jl` interface uses positional arguments for data (with data possibly including reference to some existing figure) and keyword arguments for modifying underlying attributes.

The `PlotlyLightLite.jl` interface *mostly* follows this. However, only *some* of the `Plots.jl` keyword arguments are supported. Other keyword arguments are passed directly to [Plotly](https://plotly.com/javascript/) and so should follow the naming conventions therein.

The `PlotlyLight` interface is essentially the `JavaScript` interface for `Plotly` only with the cleverly convenient `Config` constructor used to create the nested JavaScript data structures needed through conversion with `JSON3`. All arguments are like keyword arguments.

* In Plots.jl, every column is a series, a set of related points which form lines, surfaces, or other plotting primitives.

`Plotly` refers to series as traces. This style is not supported in `PlotlyLightLite`, rather multiple layers are suggested. (E.g. plot each column of a matrix.)

* In `Plots.jl` for keyword arguments many aliases are used, allowing for shorter calling patterns for experienced users.

This is not the case with `PlotlyLightLite`.

* In `Plots.jl` some arguments encompass smart [shorthands](https://docs.juliaplots.org/latest/attributes/#magic-arguments) for setting many related arguments at the same time.

This is not the case with `PlotlyLightLite`.


## Supported plotting functions

We load the package in the typical manner:

```@example lite
using PlotlyLightLite
using PlotlyDocumenter # hide
```

This package directly implements some of the `Plots` recipes for functions that lessen the need to manipulate data.

### `plot(f, a, b)`

The simplest means to plot a function `f` over the interval `[a,b]` is the declarative pattern `plot(f, a, b)`. For example:

```@example lite
plot(sin, 0, 2pi)

delete!(current().layout, :width)  # hide
delete!(current().layout, :height) # hide
to_documenter(current())           # hide
```

The `sin` object refers to a the underlying function to compute sine. More commonly, the function is user-defined as `f`, or some such, and that function object is plotted.

The interval may be specified using two numbers or with a container, in which case the limits come from calling a method of `extrema` for `Plot` objects. A default of ``(-5,5)`` is used when no interval is specified.

For line plots, as created by this usage, the supported key words include

* `linecolor` to specify the color of th eline
* `linewidth` to adjust width in pixels
* `linestyle` to adjust how line is drawn
* `legend` to indicate if no legend should be given. Otherwise, `label` can be used to name the entry for given trace.

!!! note
    All plotting functions in `PlotlyLightLite` return an instance of `PlotlyLight.Plot`. These objects can be directly modified and re-displayed. The `show` method creates the graphic for viewing. The `current` function returns the last newly created plot.


### `plot!`

Layers can be added to a figure created by `plot`. The notation follows `Plots.jl` and uses `Julia`'s convention of indicating functions which mutate their arguments with a `!`. The underlying plot is mutated (by adding a layer) and reference to this may or may not be in the `plot!` call. (When missing, the current plotting figure, determined by `current()`, is used.)

```@example lite
plot(sin, 0, 2pi)

plot!(cos)    # no limits needed, as they are computed from the current figure

plot!(x -> x, 0, pi/2)      # limits can be specified
plot!(x -> 1 - x^2/2, 0, pi/2)

delete!(current().layout, :width)  # hide
delete!(current().layout, :height) # hide
to_documenter(current())           # hide
```

### `plot([f,g,...], a, b)`

As a convenience, to plot two or more traces in a graphic, a vector of functions can be passed in. In which case, each is plotted over the interval. (Similar to using `plot` to plot the first and `plot!` to add the rest.)

The `Plots` keyword `line` arguments are recycled. For more control, using `plot!`, as above.

### `plot(xs, ys, [zs])`.

The `plot(xs, ys)` function simply connects the points
``(x_1,y_1), (x_2,y_2), \dots``  sequentially with lines in a dot-to-dot manner (the `lineshape` argument can modify this). If values in `y` are non finite, then a break in the dot-to-dot graph is made.

When `plot` is passed a  function in the first argument, the `x`-`y` values are created by `xs = unzip(f, a, b)` which uses an adaptive algorithm from `PlotUtils`; the values `x=xs` and `y=f.(xs)` are used.

Use `plot(xs, ys, zs)` for line plots in 3 dimensions, which is illustrated in a different section.

### `plot(f::Function, g::Function, a, b)` or `plot(fs::Tuple, a, b)`

Two dimensional parametric plots show the trace of ``(f(t), g(t))`` for ``t`` in ``[a,b]``. These are easily created by `plot(x,y)` where the `x` and `y` values are produced by broadcasting, say, such as `f.(ts)` where `ts = range(a,b,n)`.

The `Plots.jl` convenience signature is `plot(f::Function, g::Function, a, b)`. This packages also provides for passing a tuple of functions, as in `plot((f,g), a, b)`.

### `plot(::Array{<:Plot,N})`

Arrange an array of plot objects into a regular layout for display.

(`Plots.jl` uses a different convention.)


### `plot(; kwargs...)`

This basically is the same as `PlotlyLight`'s `Plot` function, but adds a reference so that `current` will point to the new `Plot` object.

Unlike `plot` in `Plots.jl`, the `plot` function -- except in this usage and the previous -- always producesa line plot.


### `scatter(xs, ys, [zs])`

Save for methods, the `plot` method represents the data with type `line` which instructs `Plotly` to connect points with lines.

Related to `plot` and `plot!` are `scatter` and `scatter!`; which render just the points, without connecting the dots.


The following `Plots.jl` marker attributes are supported:

* `markershape` to set the shape
* `markersize` to set the marker size
* `markercolor` to adjust the color

(In `Plotly`, just using `mode="lines+markers"` is needed to show both markers and lines, but in this interface, one would make a line plot and then layer on a scatter plot.)

### Text and arrows

The `annotate!`, `quiver!`, `arrow` and `arrow!` functions are used to add text and/or arrows to a graphic.

The `annotate!` function takes a a tuple of `(x,y,txt)` points or vectors of each and places text at the `x-y` coordinate. Text attributes can be adjusted.

The `quiver!` function plots arrows with optional text labels. Due to the underlying use of `Plotly`, `quiver` is restricted to 2 dimensions. The arguments to quiver are tail position(s) in `x` and `y` and arrow lengths, passed to `quiver` as `dx` and `dy`. The optional `txt` argument can be used to label the anchors.

The `arrow!` function is not from `Plots.jl`. It provides a different interface to arrow drawing than `quiver`. For `arrow!` the tail and vectors are passed in as vectors. (so for a single arrow from `p=[1,2]` with direction `v=[3,1]` one call would be `arrow!(p, v)` (as compared with `quiver([1],[2], quiver=([3],[1]))`). The latter more efficient for many arrows.


The following `Plots.jl` text attributes are supported:

* `color`
* `family`
* `pointsize`
* `rotation`

There is no `Text` function.

### Shapes

For simple shapes there are `hline!`, `vline!`, `rect!`, and `circle!`.

* `hline!(y)` draws a horizontal line at elevation `y` across the computed axis The `extrema` function computes the axis sizes.
* `vline(x)`  draws a vertical line at  `x` across the computed axis. The `extrema` function computes the axis sizes.
* `rect!(x0, x1, y0, y1)` draws a rectangle between `(x0,y0)` and `(x1,y1)`. The `Plotly`  arguments `fillcolor` and `opacity` can be used to fill the rectangle with color. The `line` argument of `Plotly` can be used to adjust properties of the boundary.
* `circle!(x0, x1, y0, y1)` draws a "circular" shape in the rectangle given by `(x0, y0)` and `(x1, y1)`. The `Plotly`  arguments `fillcolor` and `opacity` can be used to fill the circle with color. The `line` argument of `Plotly` can be used to adjust properties of the boundary.


----


For example, this shows how one could visualize the points chosen in a plot, showcasing both `plot` and `scatter!` in addition to a few other plotting commands:

```@example lite
f(x) = x^2 * (108 - 2x^2)/4x
x, y = unzip(f, 0, sqrt(108/2))
plot(x, y; legend=false)
scatter!(x, y, markersize=10)

quiver!([2,4.3,6],[10,50,10], ["sparse","concentrated","sparse"],
        quiver=([-1,0,1/2],[10,15,5]))

# add rectangles to emphasize plot regions
y0, y1 = extrema(current()).y  # get extent in `y` direction
rect!(0, 2.5, y0, y1, fillcolor="#d3d3d3", opacity=0.2)
rect!(2.5, 6, y0, y1, line=(color="black",), fillcolor="orange", opacity=0.2)
x1 = last(x)
rect!(6, x1, y0, y1, fillcolor="rgb(150,150,150)", opacity=0.2)

delete!(current().layout, :width)  # hide
delete!(current().layout, :height) # hide
to_documenter(current())           # hide
```

The values returned by `unzip(f, a, b)` are not uniformly chosen, rather where there is more curvature there is more sampling. For illustration purposes, this is emphasized in a few ways: using `quiver!` to add labeled arrows and `rect!` to add rectangular shapes with transparent filling.


### Keyword arguments

The are several keyword arguments used to adjust the defaults for the graphic, for example, `legend=false` and `markersize=10`. Some keyword names utilize `Plots.jl` naming conventions and are translated back to their `Plotly` counterparts. Additional keywords are passed as is, so should use the `Plotly` names.

Some keywords chosen to mirror `Plots.jl` are:

| Argument | Used by | Notes |
|:---------|:--------|:------|
| `width`, `height` | new plot calls | set figure size, cf. `size!` |
| `xlims`, `ylims`  | new plot calls | set figure boundaries, cf `xlims!`, `ylims!`, `extrema` |
| `legend`          | new plot calls | set or disable legend |
|`aspect_ratio`     | new plot calls | set to `:equal` for equal `x`-`y` (and `z`) axes |
|`label`	    	| `plot`, `plot!`| set with a name for trace in legend |
|`linecolor`		| `plot`, `plot!`| set with a color |
|`linewidth`		| `plot`, `plot!`| set with an integer |
|`linestyle`		| `plot`, `plot!`| set with `"solid"`, `"dot"`, `"dash"`, `"dotdash"`, ... |
|`lineshape`		| `plot`, `plot!`| set with `"linear"`, `"hv"`, `"vh"`, `"hvh"`, `"vhv"`, `"spline"` |
|`markershape`		| `scatter`, `scatter!` | set with `"diamond"`, `"circle"`, ... |
|`markersize`		| `scatter`, `scatter!` | set with integer |
|`markercolor`		| `scatter`, `scatter!` | set with color |
|`color`			| `annotate!` | set with color |
|`family`			| `annotate!` | set with string (font family) |
|`pointsize`		| `annotate!` | set with integer |
|`rotation`        	| `annotate!` | set with angle, degrees  |
|`center`		   	| new ``3``d plots | set with tuple, see [controls](https://plotly.com/python/3d-camera-controls/) |
|`up`				| new ``3``d plots | set with tuple, see [controls](https://plotly.com/python/3d-camera-controls/) |
|`eye`				| new ``3``d plots | set with tuple, see [controls](https://plotly.com/python/3d-camera-controls/) |

As seen in the example there are *many* ways to specify a color. These can be by name (as a string); by name (as a symbol), using HEX colors, using `rgb` (the use above passes a JavaScript command through a string). There are likely more.

One of the `rect!` calls has a `line=(color="black",)` specification. This is a keyword argument from `Plotly`. Shapes have an interior and exterior boundary. The `line` attribute is used to pass in attributes of the boundary line, in this case the line color is set to black. A `Config` object or *named tuple* is used (which is why the trailing comma is needed for this single-element tuple).

### Other methods

As seen in this overblown example, there are other methods to plot different things. These include:

* `scatter!` is used to plot points

* `annotate!` is used to add annotations at a given point. There are keyword arguments to adjust the text size, color, font-family, etc.  There is also `quiver` which adds arrows and these arrows may have labels. The `quiver` command allows for text rotation.

* `quiver!` is used to add arrows to a plot. These can optionally have their tails labeled, so this method can be repurposed to add annotations.

* `rect!` is used to make a rectangle. `Plots.jl` uses `Shape`. See also `circle!`.

* `hline!` `vline!` to draw horizontal or vertical lines across the extent of the plotting region

Some exported names are used to adjust a plot after construction:

* `title!`, `xlabel!`, `ylabel!`, `zlabel!`: to adjust title; ``x``-axis label; ``y``-axis label
* `xlims!`, `ylims!`, `zlims!`: to adjust limits of viewing window
* `xaxis!`, `yaxis!`, `zaxis!`: to adjust the axis properties

!!! note "Subject to change"
    There are some names for keyword arguments that should be changed.
