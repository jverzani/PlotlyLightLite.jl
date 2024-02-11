# PlotlyLightLite.jl

Documentation for [PlotlyLightLite](https://github.com/jverzani/PlotlyLightLite.jl), a package to give `Plots`-like access to `PlotlyLight` for the graphs of Calculus.

This package provides a light-weight alternative to `Plots.jl` which utilizes basically a subset of the `Plots` interface. It is inspired by `SimplePlots` and is envisioned as being useful within resource-constrained environments such as [`binder.org`](https://mybinder.org/v2/gh/mth229/229-projects/lite?labpath=blank-notebook.ipynb).

```@example lite
using PlotlyLightLite
using PlotlyDocumenter # hide
```

The plotting interface provided picks some of the many parts of `Plots.jl` that prove useful for the graphics of calculus and provides a stripped-down, though reminiscent, interface using `PlotlyLight`, a package which otherwise is configured in a manner very-much like the underlying `JavaScript` implementation. The `Plots` package is great -- and has a `Plotly` backend -- but for resource-constrained usage can be too demanding.

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

The `plot(x, y)` function simply connects the points
``(x_1,y_1), (x_2,y_2), \dots``  with a line in a dot-to-dot manner (the `lineshape` argument can modify this). If values in `y` are non finite, then a break in the dot-to-dot graph is made.

When `plot` is passed a  function in the first argument, the `x`-`y` values are created by `unzip(f, a, b)` which uses an adaptive algorithm from `PlotUtils`.

Use `plot(x,y,z)` for plotting lines in 3 dimensions. For parameterized function, a tuple of functions (2 or 3) and an interval may be given.

### `scatter`

Related to `plot` and `plot!` is `scatter` (and `scatter!`) which plots just the points, but has no connecting dots. The marker shape, size, and color can be adjusted by keyword arguments.

### Text and arrows

The `annotate!`, `quiver!`, `arrow` and `arrow!` functions are used to add text and/or arrows to a graphic.


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

(The use of tuples to pair functions is idiosyncratic; the `Plots.jl` style of passing functions for the first 2 or 3 positional arguments is also supported.)



Using a single function returning a point may be more natural for some usages. Below we use `unzip` to take a container of points into 3 containers for the coordinates, `x`, `y`, `z` to pass to `plot(x,y,z)`:

```@example lite
r(t) = (sin(t), cos(t), t)
rp(t) = (cos(t), -sin(t), 1)

ts = range(0, 4pi, length=251)
plot(unzip(r.(ts))...)
ts = range(0, 4pi, length=10)
arrow!(r.(ts), rp.(ts))

delete!(current().layout, :width)  # hide
delete!(current().layout, :height) # hide
to_documenter(current())           # hide
```

Contour, heatmaps, and surface plots can be produced by `contour`, heatmap, and `surface`. This example uses the [`peaks`](https://www.mathworks.com/help/matlab/ref/peaks.html) function of MATLAB:

```@example lite
function peaks(x,y)
    z = 3 * (1-x)^2 * exp(-(x^2) - (y+1)^2)
    z = z - 10 * (x/5 - x^3 - y^5) * exp(-x^2-y^2)
    z = z - 1/3 * exp(-(x+1)^2 - y^2)
end
xs = range(-3, 3, length=100)
ys = range(-2, 2, length=100)
contour(xs, ys, peaks)
```

```@example lite
surface(xs, ys, peaks)
```

Parametric surfaces can be produced as follows, where, in this usage, `unzip` creates 3 matrices to pass to `surface`:

```@example lite
r1, r2 = 2, 1/2
r(u,v) = ((r1 + r2*cos(v))*cos(u), (r1 + r2*cos(v))*sin(u), r2*sin(v))
us = vs = range(0, 2pi, length=25)
surface(unzip(us, vs, r)...)
```

This last example shows how to plot a surface and two planes along with their intersections emphasized. The latter uses the `Contours` package. One plane use the form ``ax + by + cz = d`` which for non-zero `c` has `z(x,y)` solvable and is plotted as surface. The intersection of the surface and the plane is the ``0``-level contour of the function ``f(x,y) - z(x,y)``.

The other plane has ``c=0``, so is plotted differently. That plane is [described](https://community.plotly.com/t/slicing-3d-surface-plot-along-a-user-selected-axis/40771/6) as lying in the direction of the vectors ``[a,b,0]`` and ``[0,0,1]]`` and going through the point ``[x_0, y_0, 0]``. This gives ``b(x-x_0) - a(y-y_0) = 0``. The intersecion can be found by projecting the line in the ``x-y`` plane onto the surface.

```@example lite
f(x, y) = 4 - x^2 - y^2

xs = ys = range(-2, 2, length=100)
surface(xs, ys, f; legend=false, showscale=false)

# plane of the from a*x + b*y + c*z = d, c != 0
a,b,c,d = 1,1,1,2.5
z(x,y) = (d - a*x - b*y) / c
surface!(xs, ys, z, opacity=0.25, showscale=false)

# One way to plot intersection numerically
import Contour
cs = Contour.contours(xs, ys, ((x,y) -> f(x,y) - z(x,y)).(xs', ys), [0])
for cl ∈ Contour.levels(cs)
    for line in Contour.lines(cl)
        xₛ, yₛ = Contour.coordinates(line) # coordinates of this line segment
        plot!(xₛ, yₛ, z.(xₛ, yₛ), linecolor="black", linewidth=10)
    end
end

# plane parallel to [a,b,0], [0,0,1] and through [x0,y0,0]
a,b = 1, 1
x0, y0 = 0, 0 # origin

zs = range(-4, 4, length=100) # or extrema(z.(xs', ys))
Xs = ((x,z) -> x).(xs', zs)
Zs = ((x,z) -> z).(xs', zs)

c, d = 0, b*x0 - a * y0
plane(x,z) = (d + a*x - c*z) / b
Ys = plane.(xs', zs)
surface!(Xs, Ys, Zs, opacity=0.25, showscale=false)

g(t) = (b*t -d)/a # line in x-y plane
xxs = xs
yys = g.(xxs)
zzs = f.(xxs, yys)
plot!(xxs, yys, zzs, linewidth=10, linecolor="black")
```


!!! note "FIXME"
    The above surface and contour graphics aren't rendering properly in the documentation, so aren't shown.

### Keyword arguments

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

### Other methods

As seen in this overblown example, there are other methods to plot different things. These include:

* `scatter!` is used to plot points

* `annotate!` is used to add annotations at a given point. There are keyword arguments to adjust the text size, color, font-family, etc.  There is also `quiver` which adds arrows and these arrows may have labels. The `quiver` command allows for text rotation.

* `quiver!` is used to add arrows to a plot. These can optionally have their tails labeled, so this method can be repurposed to add annotations.

* `contour` is used to create contour plots

* `heatmap` is used to create heatmpa plots

* `surface` is used to plot ``3``-dimensional surfaces.

* `rect!` is used to make a rectangle. `Plots.jl` uses `Shape`. See also `circle!`.

* `hline!` `vline!` to draw horizontal or vertical lines across the extent of the plotting region

Some exported names are used to adjust a plot after construction:

* `title!`, `xlabel!`, `ylabel!`: to adjust title; ``x``-axis label; ``y``-axis label
* `xlims!`, `ylims!`: to adjust limits of viewing window
* `xaxis!`, `yaxis!`: to adjust the axis properties
* `plot` to specify a cell-like layout using a matrix of plots.

!!! note "Subject to change"
    There are some names for keyword arguments that should be changed.
