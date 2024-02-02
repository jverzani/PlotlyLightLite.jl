# PlotlyLightLite.jl

Documentation for [PlotlyLightLite](https://github.com/jverzani/PlotlyLightLite.jl), a package to give `Plots`-like access to `PlotlyLight` for the graphs of Calculus.

This package provides a light-weight alternative to `Plots.jl` which utilizes basically a subset of the `Plots` interface. It is inspired by `SimplePlots` and is envisioned as being useful within resource-constrained environments such as `binder.org`.

```@example lite
using PlotlyLightLite
using PlotlyDocumenter # hide
```

The plotting interface provided picks some of the many parts of `Plots.jl` that prove useful for the graphics of calculus and provides a stripped-down, though reminiscent interface using `PlotlyLight`, a package which otherwise is configured in a manner very-much like the underlying `JavaScript` implementation. The `Plots` package is great -- and has `Plotly` as a backend -- but for resource-constrained usage can be too demanding.

## Supported plotting functions

### `plot`

The simplest means to plot a function `f` over the interval `[a,b]` is the pattern `plot(f, a, b)`. For example:

```@example lite
plot(sin, 0, 2pi)

delete!(current().layout, :width)  # hide
delete!(current().layout, :height) # hide
to_documenter(current())           # hide
```

The `sin` object refers to a the underlying function to compute sine. More commonly, the function is user-defined as `f`, or some such, and that function object is plotted. The interval may be specified using two numbers or with a container, in which case the limits come from calling `extrema`.

### `plot!`

Layers can be added to a basic plot. The notation follows `Plots.jl` and uses `Julia`'s convention of indicating functions which mutate their arguments with a `!`. The underlying plot is mutated (by adding a layer) and reference to this may or may not be in the `plot!` call. (When missing, the current plotting figure, determined by `current()`, is used.)

```@example lite
plot(sin, 0, 2pi)

plot!(cos)    # no limits needed, as they are computed from the current figure

plot!(x -> x, 0, pi/2)      # limits can be specified
plot!(x -> 1 - x^2/2, 0, pi/2)

delete!(current().layout, :width)  # hide
delete!(current().layout, :height) # hide
to_documenter(current())           # hide
```

As a convenience, a vector of functions can be passed in. In which case, each is plotted over the interval. The keyword arguments are passed to the first function only. For more control, using `plot!`, as above.

### `plot(x, y)`.

The `plot(x, y)` function simply connects the points ``(x_1,y_1), (x_2,y_2),\dots``  with a line in a dot-to-dot manner (the `lineshape` argument can modify this). If values in `y` are non finite, then a break in the dot-to-dot graph is made.

When `plot` is passed a  function in the first argument, the `x`-`y` values are created by `unzip(f, a, b)` which uses an adaptive algorithm from `PlotUtils`.


### `scatter`

Related to `plot` and `plot!` is `scatter` (and `scatter!`) which plots just the points, but has no connecting dots. The marker shape, size, and color can be adjusted by keyword arguments.

### Text and arrows

The `annotate!` and `quiver!` functions are used to add text and/or arrows


### Shapes

For basic shapes there are `hline!`, `vline!`, `rect!`. and `circle!`.

----


For example, this shows how one could visualize the points chosen in a plot, showcasing both `plot` and `scatter!` in addition to a few other plotting commands:

```@example lite
using Roots

f(x) = x^2 * (108 - 2x^2)/4x
x, y = unzip(f, 0, sqrt(108/2))
plot(x, y; legend=false)
scatter!(x, y, markersize=10)

quiver!([2,4.3,6],[10,50,10], ["sparse","concentrated","sparse"],
        quiver=([-1,0,1/2],[10,15,5]))

# add rectangles to emphasize plot regions
y0, y1 = extrema(current()).y  # get extent in `y` direction
rect!(0, 2.5, y0, y1, fillcolor="#d3d3d3", opacity=0.2)
rect!(2.5,6, y0, y1, line=(color="black",), fillcolor="orange", opacity=0.2)
rect!(6, find_zero(f, 7), y0, y1, fillcolor="rgb(150,150,150)", opacity=0.2)

delete!(current().layout, :width)  # hide
delete!(current().layout, :height) # hide
to_documenter(current())           # hide
```

The values returned by `unzip(f,a, b)` are not uniformly chosen, rather where there is more curvature there is more sampling. For illustration purposes, this is emphasized in a few ways: using `quiver!` to add labeled arrows and `rect!` to add rectangular shapes with transparent filling.

### Other graphs

Parametric plots can be easily created by using a tuple of functions, as in:

```@example lite
plot((sin, cos, x -> x), 0, 4pi)

delete!(current().layout, :width)  # hide
delete!(current().layout, :height) # hide
to_documenter(current())           # hide
```


Contour and surface plots can be produced by `contour` and `surface`. This example uses the [`peaks`](https://www.mathworks.com/help/matlab/ref/peaks.html) function of MATLAB:

```@example lite
function peaks(x,y)
	z = 3*(1-x)^2* exp(-(x.^2) - (y+1)^2)
	z = z - 10*(x/5 - x^3 - y^5) * exp(-x^2-y^2)
    z = z - 1/3*exp(-(x+1)^2 - y^2)
end
xs = range(-3, 3, length=100)
ys = range(-2, 2, length=100)
contour(xs, ys, peaks)

delete!(current().layout, :width)  # hide
delete!(current().layout, :height) # hide
to_documenter(current())           # hide
```

```@example lite
surface(xs, ys, peaks)

delete!(current().layout, :width)  # hide
delete!(current().layout, :height) # hide
to_documenter(current())           # hide
```

!!! note "FIXME"
    The above surface and contour graphics aren't rendering properly in the documentation.

### keyword arguments

The are several keyword arguments used to adjust the defaults for the graphic, for example, `legend=false` and `markersize=10`. Some keyword names utilize `Plots.jl` naming conventions and are translated back to their `Plotly` counterparts. Additional keywords are passed as is so should use the `Plotly` names.

Some keywords chosen to mirror `Plots.jl` are:

| Argument | Used by | Notes |
|:---------|:--------|:------|
| `width`, `height` | new plot calls | set figure size, cf. `size!` |
| `xlims`, `ylims`  | new plot calls | set figure boundaries, cf `xlims!`, `ylims!`, `extrema` |
| `legend`          | new plot calls | set or disable legend |
|`aspect_ratio`     | new plot calls | set to `:equal` for equal `x`-`y` axes |
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

One of the `rect!` calls has a `line=(color="black",)` specification. This is a keyword argument from `Plotly`. Shapes have an interior and exterior boundary. The `line` attribute is used to pass in attributes, in this case the line color is black. A *named tuple* is used (which is why the trailing comma is needed for this single element tuple).

As seen in this overblown example, there are other methods to plot different things. These include:

* `scatter!` is used to plot points

* `annotate!` is used to add annotations at a given point. There are keyword arguments to adjust the text size, color, font-family, etc.  There is also `quiver` which adds arrows and these arrows may have labels. The `quiver` command allows for text rotation.

* `quiver!` is used to add arrows to a plot. These can optionally have their tails labeled, so this method can be repurposed to add annotations.

* `contour` is used to create contour plots

* `surface` is used to plot ``3``-dimensional surfaces.

* `rect!` is used to make a rectangle. `Plots.jl` uses `Shape`. See also `circle!`.

* `hline!` `vline!` to draw horizontal or vertical lines across the extent of the plotting region

Some exported names are used to adjust a plot after construction:

* `title!`, `xlabel!`, `ylabel!`: to adjust title; ``x``-axis label; ``y``-axis label
* `xlims!`, `ylims!`: to adjust limits of viewing window
* `xaxis!`, `yaxis!`: to adjust the axis properties
* `grid_layout` to specify a cell-like layout using a matrix of plots.

!!! note "Subject to change"
    There are some names for keyword arguments that should be changed.
