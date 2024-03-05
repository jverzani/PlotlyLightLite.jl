
# generalize shapes (line, rect, circle, ...)
# fillcolor
# line.color
function _shape(type, x0, x1, y0, y1;
                linecolor = nothing,
                linewidth = nothing,
                linestyle = nothing,
                kwargs...)



    c = Config(; type, x0, x1, y0, y1)
    _merge!(c; kwargs...)

    line = Config()
    !isnothing(linecolor) && (line.color = linecolor)
    !isnothing(linewidth) && (line.width = linewidth)
    !isnothing(linestyle) && (line.style = linestyle)

    !isnothing(line) && (c.line = line)
    c
end

function _add_shape!(p::Plot, d)
    if isempty(p.layout.shapes)
        p.layout.shapes = [d]
    else
        push!(p.layout.shapes, d)
    end
    p
end

function _add_shapes!(p::Plot, ps; kwargs...)
    if isa(ps, Config)
        _add_shape!(p, ps)
    else
        for s ∈ ps
            _add_shape!(p, s)
        end
    end
end


"""
    vline!(x; ymin=0, ymax=1.0; kwargs...)

Draw vertical line at `x`. By default extends over the current plot range, this can be adjusted by `ymin` and `ymax`, values in `[0,1]`.

The values for `x`, `ymin`, and `ymax` are broadcast.

A current plot must be made to add to, as the extent of the lines is taken from that.

# Example

Add a grid to a plot:

```
p = plot(x -> x^2, 0, 1; aspect_ratio=:equal)
vline!(0:.1:1, linecolor=:red,  opacity=0.25, linewidth=5)
hline!(0:.1:1, linecolor=:blue, opacity=0.75)
```

"""
vline!(x; kwargs...) = vline!(current_plot[], x; kwargs...)
function vline!(p::Plot, x; ymin = 0.0, ymax = 1.0, kwargs...)
    a, b = extrema(p).y
    Δ = b - a
    λ = (x,m,M) -> _shape("line", x, x, a + m*Δ, a + M*Δ; mode="Line", kwargs...)
    ps = λ.(x, ymin, ymax)

    _add_shapes!(p, ps)

    p
end

"""
    hline!(y; xmin=0, xmax=1.0; kwargs...)

Draw horizontal line at `y`. By default extends over the current plot range, this can be adjusted by `xmin` and `xmax`, values in `[0,1]`.

The values for `y`, `xmin`, and `xmax` are broadcast.

A current plot must be made to add to, as the extent of the lines is taken from that.
"""
hline!(x; kwargs...) = hline!(current_plot[], x; kwargs...)
function hline!(p::Plot, y; xmin = 0.0, xmax = 1.0, kwargs...)
    a, b = extrema(p).x
    Δ = b - a
    λ = (y,m,M) -> _shape("line", a + m*Δ, a + M*Δ, y, y; mode="line",kwargs...)
    ps = λ.(y,xmin, xmax)

    _add_shapes!(p, ps)
    p
end


"""
    rect!([p::Plot], x0, x1, y0, y1; kwargs...)

Draw rectangle shape on graphic.

# Example

```
rect!(p, 2,3,-1,1; linecolor=:gray, fillcolor=:red, opacity=0.2)
```
"""
function rect!(p::Plot, x0, x1, y0, y1; kwargs...)
    _add_shape!(p, _shape("rect", x0, x1, y0, y1; kwargs...))
end
rect!(x0, x1, y0, y1; kwargs...) = rect!(current_plot[], x0, x1, y0, y1; kwargs...)


"""
    hspan!([p::Plot], ys, YS; xmin=0.0, ymin=1.0, kwargs...)

Draw horizontal rectanglular rectangle from `ys` to `YS`. By default extends over `x` range of plot `p`, though using `xmin` or `xmax` can adjust that.
"""
hspan!(ys,YS; kwargs...) = hspan!(current_plot[], ys, YS; kwargs...)
function hspan!(p::Plot, ys, YS; xmin=0.0, xmax=1.0, kwargs...)
    a, b = extrema(p).x
    Δ = b - a
    λ = (m,M,y0,y1) -> _shape("rect", a + m*Δ, a + M*Δ, y0, y1; kwargs...)
    ps = λ.(xmin, xmax, ys, YS)

    _add_shapes!(p, ps)

    p
end

"""
    vspan!([p::Plot], xs, XS; ymin=0.0, ymin=1.0, kwargs...)

Draw vertical rectanglular rectangle from `xs` to `XS`. By default extends over `y` range of plot `p`, though using `ymin` or `ymax` can adjust that.

# Example

```
p = plot(x -> x^2, 0, 1; legend=false)
vspan!(0:.1:0.9, 0.1:0.1:1.0; ymax=[x^2 for x in 0:.1:0.9],
    fillcolor=:red, opacity=.25)
```
"""
vspan!(xs, XS; kwargs...) = vspan!(current_plot[], xs, XS; kwargs...)
function vspan!(p::Plot, xs, XS; ymin=0.0, ymax=1.0, kwargs...)
    a, b = extrema(p).y
    Δ = b - a
    λ = (x0,x1,m,M) -> _shape("rect", x0,x1,a + m*Δ, a + M*Δ; kwargs...)
    ps = λ.(xs, XS, ymin, ymax)

    _add_shapes!(p, ps)

    p
end

# XXX poly (?https://docs.makie.org/stable/reference/plots/poly/)
"""
    poly(points; kwargs...)
    poly!([p::Plot], points; kwargs...)

Plot polygon described by `points`, a container of `x-y` or `x-y-z` values.

Example

```
f(r,θ) = (r*cos(θ), r*sin(θ))
poly(f.(repeat([1,2],5), range(0, 2pi-pi/5, length=10)))
```
"""
function poly(points; kwargs...)
    p = _new_plot(; kwargs...)
    poly!(p, points; kwargs...)
end
poly!(points; kwargs...) = poly!(current_plot[], points; kwargs...)
function poly!(p::Plot,points;
               linecolor=nothing,
               linewidth=nothing,
               linestyle=nothing,
               lineshape=nothing,
               color = nothing,
               kwargs...)
    x,y = unzip(points)
    if (first(x) != last(x)) || (first(y) != last(y))
        x, y = collect(x), collect(y)
        push!(x, first(x))
        push!(y, first(y))
    end
    cfg = Config(;x,y,type="line", color=color, fill="toself", kwargs...)
    _linestyle!(cfg; linecolor, linewidth, linestyle, lineshape)
    push!(p.data, cfg)
    p
end



"""
    circle([p::Plot], x0, x1, y0, y1; kwargs...)

Draw circle shape bounded in `[x0, x1] × [y0,y1]`. (Will adjust to non-equal sized boundary.)
# Example
Use named tuple for `line` for boundary.
```
circle!(p, 2,3,-1,1; line=(color=:gray,), fillcolor=:red, opacity=0.2)
```
"""
function circle!(p::Plot, x0, x1, y0, y1; kwargs...)
    _add_shape!(p, _shape("circle", x0, x1, y0, y1; kwargs...))
end
circle!(x0, x1, y0, y1; kwargs...) =
    circle!(current_plot[], x0, x1, y0, y1; kwargs...)
