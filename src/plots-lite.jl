## --- plotting

## utils
const current_plot = Ref{Plot}() # store current plot
const first_plot = Ref{Bool}(true) # for first plot warning

"""
    current()

Get current figure. A `Plot` object of `PlotlyLight`; `UndefRefError` if none.

Not typically needed, as it is implicit in most mutating calls, though may be convenient if those happen within a loop.

"""
current() = current_plot[]

# make a new plot by calling `PlotlyLight.Plot`
function _new_plot(;
                   width=800, height=600,
                   xlims=nothing, ylims=nothing,
                   legend = nothing,
                   aspect_ratio=nothing,
                   kwargs...)
    p = Plot(Config[],
             Config(), # layout
             Config(responsive=true) ) # config
    current_plot[] = p

    if first_plot[]
        @info "For the first plot, you may need to re-run your command to see the plot"
        first_plot[] = false
    end

    size!(p, width=width, height=height)
    xlims!(p, xlims)
    ylims!(p, ylims)

    # layout
    legend!(p, legend)
    aspect_ratio == :equal && (p.layout.yaxis.scaleanchor="x")

    p
end

# plot attributes

"""
    title!([p::Plot], txt)
    xlabel!([p::Plot], txt)
    ylable!([p::Plot], txt)
    zlabel!([p::Plot], txt)

Set plot title.
"""
function title!(p::Plot, txt)
    p.layout.title = txt
    p
end
title!(txt) = title!(current_plot[], txt)

xlabel!(p::Plot, txt) = (p.layout.xaxis.title=txt;p)
xlabel!(txt) = xlabel!(current_plot[], txt)

ylabel!(p::Plot, txt) = (p.layout.yaxis.title=txt;p)
ylabel!(txt) = ylabel!(current_plot[], txt)

zlabel!(p::Plot, txt) = (p.layout.zaxis.title=txt;p)
zlabel!(txt) = zlabel!(current_plot[], txt)

"""
    xaxis!([p::Plot]; kwargs...)
    yaxis!([p::Plot]; kwargs...)
    zaxis!([p::Plot]; kwargs...)

Adjust ticks on chart.
* ticks: a container or range
* ticklabels: optional labels (same length as `ticks`)
* showticklabels::Bool
"""
xaxis!(p::Plot; kwargs...) = (_merge!(p.layout.xaxis, _axis(;kwargs...)); p)
xaxis!(;kwargs...) = xaxis!(current_plot[]; kwargs...)
yaxis!(p::Plot; kwargs...) = (_merge!(p.layout.yaxis, _axis(;kwargs...)); p)
yaxis!(;kwargs...) = yaxis!(current_plot[]; kwargs...)
zaxis!(p::Plot; kwargs...) = (_merge!(p.layout.zaxis, _axis(;kwargs...)); p)
zaxis!(;kwargs...) = zaxis!(current_plot[]; kwargs...)
# https://plotly.com/javascript/tick-formatting/ .. more to do
function _axis(;ticks=nothing, ticktext=nothing, showticklabels=nothing,
               autotick=nothing, showgrid=nothing, zeroline=nothing,
               kwargs...
                )
    d = Config()
    if !isnothing(ticks)
        if isa(ticks, AbstractRange)
            tickvals, tick0, dtick, nticks = nothing, first(ticks), step(ticks), length(ticks)
        else
            tickvals, tick0, dtick, nticks = ticks, nothing, nothing, nothing
        end
        _merge!(d; tickvals, tick0, dtick, nticks)
    end
    _merge!(d; ticktext, showticklabels, autotick, showgrid, zeroline)
    d
end

"`legend!([p::Plot], legend::Bool)` hide/show legend"
legend!(p::Plot, legend=nothing) = !isnothing(legend) && (p.layout.showlegend = legend)
legend!(val::Bool) = legend!(current_plot[], val)

"`size!([p::Plot]; [width], [height])` specify size of plot figure"
function size!(p::Plot; width=nothing, height=nothing)
    !isnothing(width) && (p.layout.width=width)
    !isnothing(height) && (p.layout.height=height)
    p
end
size!(;width=nothing, height=nothing) = size!(current_plot[]; width, height)

"`xlims!(p, lims)` set `x` limits of plot"
function xlims!(p::Plot, lims)
    p.layout.xaxis.range = lims
    p
end
xlims!(p::Plot, ::Nothing) = p
xlims!(lims) = xlims!(current_plot[], lims)

"`ylims!(p, lims)` set `y` limits of plot"
function ylims!(p::Plot, lims)
    p.layout.yaxis.range = lims
    p
end
ylims!(p::Plot, ::Nothing) = p
ylims!(lims) = ylims!(current_plot[], lims)

"`zlims!(p, lims)` set `z` limits of plot"
function zlims!(p::Plot, lims)
    p.layout.xaxis.range = lims
    p
end
zlims!(p::Plot, ::Nothing) = p
zlims!(lims) = zlims!(current_plot[], lims)

"`scrollzoom!([p], x::Bool)` turn on/off scrolling to zoom"
scroll_zoom!(p::Plot,x::Bool) = p.config.scrollZoom = x
scroll_zoom!(x::Bool) = scroll_zoom!(current_plot[], x)

## ---- configuration
# These gather specific values for lines, marker and text style

# linecolor - color
# linewidth - integer
# linestyle: solic, dot, dashdot, ...
# lineshape: linear, hv, vh, hvh, vhv, spline
function _linestyle!(cfg::Config;
                     linecolor = nothing, # string, symbol, RGB?
                     linewidth = nothing, # pixels
                     linestyle = nothing, # solid, dot, dashdot,
                     lineshape = nothing,
                     kwargs...)
    _merge!(cfg.line; color=linecolor, width=linewidth, dash=linestyle,
            shape=lineshape)
    _merge!(cfg; kwargs...)
end


function _markerstyle!(cfg::Config;
                       markershape = nothing,
                       markersize  = nothing,
                       markercolor = nothing,
                       kwargs...)
    _merge!(cfg.marker; symbol=markershape, size=markersize, color=markercolor)
    _merge!(cfg; kwargs...)
end

function _textstyle!(cfg::Config;
                     color     = nothing,
                     family    = nothing,
                     pointsize = nothing,
                     rotation  = nothing,
                     kwargs...)
    _merge!(cfg.textfont, color=color, family=family, size=pointsize,
            textangle=rotation)
    _merge!(cfg; kwargs...)
end

# The camera position and direction is determined by three vectors: up, center, eye.
#
# Their coordinates refer to the 3-d domain, i.e., (0, 0, 0) is always the center of the domain, no matter data values.
#
# The eye vector determines the position of the camera. The default is $(x=1.25, y=1.25, z=1.25)$.
#
# The up vector determines the up direction on the page. The default is $(x=0, y=0, z=1)$, that is, the z-axis points up.
#
#  The projection of the center point lies at the center of the view. By default it is $(x=0, y=0, z=0)$. [https://plotly.com/python/3d-camera-controls/]
#
function _camera_position!(camera::Config;
                          center,
                          up,
                          eye)
    _merge!(camera; center)
    _merge!(camera; up)
    _merge!(camera; eye)
end

## -----
# layout
# plots has plot(p1,p2, ...; layout=(m,n))
# makie has [p1 p2; ...] display layout
# this is in between
function plot(ps::Array{<:Plot, N}; kwargs...) where {N}
    1 <= N <= 2 || throw(ArgumentError("1 or 2 dimensional arrays only"))
    grid_layout(ps; kwargs...)
end


"""
    grid_layout(ps::Array{<:Plot})

Layout an array of plots into a grid. Vectors become rows of plots.

Use `Plot()` to create an empty plot for a given cell.

# Example

```
using DataFrames
n = 25
d = DataFrame(x=sin.(rand(n)), y=rand(n).^2, z = rand(n)) # assume all numeric
nms = names(d)
m = Matrix{Plot}(undef, length(nms), length(nms))

for i ∈ eachindex(nms)
    for j ∈ eachindex(nms)
        if j > i
            p = Plot()
        elseif j == i
            x = d[:,j]
            p = plot(x, type="histogram")
            xlabel!(p, nms[j])  # <<- not working in grid! as differe xaxis purposes
        else
            x = d[:,i]; y = d[:,j]
            p = scatter(x, y)
            xlabel!(p, nms[i]); ylabel!(p, nms[j])
        end
        m[i,j] = p
    end
end
grid_layout(m)
```
"""
function grid_layout(ps::Array{<:Plot};
                     pattern="independent", # or "coupled"
                     legend = false,
                     )
    mn = size(ps)
    if length(mn) == 1
        m, n = (1, only(mn))
    else
        m, n = mn
    end

    layout = Config()
    layout.grid.rows = m
    layout.grid.columns = n
    !isnothing(pattern) && (layout.grid.pattern = pattern)
    !isnothing(legend) && (layout.showlegend = legend)

    data = Config[]
    for (i,p) ∈ enumerate(permutedims(ps))
        xi,yi = "x$i", "y$i"
        for d ∈ p.data
            isempty(d) && continue
            d.xaxis = xi
            d.yaxis = yi
            push!(data, d)
        end
    end

    Plot(data, layout)
end


include("plot.jl")
include("scatter.jl")
include("surface.jl")
include("2d-plots.jl")
include("shapes.jl")
include("3d-shapes.jl")
include("annotate.jl")
include("arrows.jl")
