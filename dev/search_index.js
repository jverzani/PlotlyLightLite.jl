var documenterSearchIndex = {"docs":
[{"location":"reference/","page":"Reference/API","title":"Reference/API","text":"Modules = [PlotlyLightLite]","category":"page"},{"location":"reference/#PlotlyLightLite.PlotlyLightLite","page":"Reference/API","title":"PlotlyLightLite.PlotlyLightLite","text":"PlotlyLightLite is a lightweight interface to the underlying PlotlyLight package (Fastest time-to-first-plot in Julia!), itself an \"ultra-lightweight interface\" to the Plotly javascript libraries. PlotlyLightLite supports some of the Plots.jl interface for plotting. This package may be of use as an alternative to Plots in resource-constrained environments, such as binder.\n\nPlots.jl uses\n\npositional arguments for data\nkeyword arguments for attributes\nplot() is a workhorse with seriestype indicating which plot; there are alos special methods (e.g. scatter(x,y) --> plot(x,y; seriestype=\"scatter\"))\n\nPlotlyLight uses\n\ndata::Vector{Config} to hold tracts of data for plotting\nlayout::Config to adjust layout\nconfig::Config to adjust global configuations\nConfig very flexibly creates the underlying Javascript objects the plotly interface expects\nPlot() is a workhorse with type acting like seriestype and also mode\n\nPlotlyLightLite has this dispatch for plot:\n\nmerge layout config, pass kwargs to Config push onto data or merge onto last tract:\n\nplot(; layout::Config?, config::Config, kwargs...) plot!(; layout::Config?, config::Config, kwargs...)\n\nLine plot. connecting x,y (and possibly z). For 2D, use !isfinite values in y to break.\n\nplot(x,y,[z]; kwargs...) plot!(x,y,[z]; kwargs...) plot!(p::Plot,x, y,[z]; kwargs...\n\nData can be generated from a function:\n\nplot(f::Function, ab; kwargs...) – plot(unzip(f,ab)...; kwargs...) plot(f::Function, a, b; kwargs...) – plot(unzip(f,a, b)...; kwargs...) plot!([p::Plot], f, ab, [b])\n\nplot each function as lineplot:\n\nplot(fs::Vector{Function}, a, [b]; kwargs...) plot!(fs::Vector{Function}, a, [b]; kwargs...)\n\n!!! currently x,y make vector; should matrices be supported using column vectors? \"In Plots.jl, every column is a series, a set of related points which form lines, surfaces, or other plotting primitives. \"\n\nParametric line plots, 2 or 3d\n\nplot(fs::NTuple(N,Function), a, [b]; kwargs...) plot!([p::Plot], fs::NTuple(N,Function), a, [b]; kwargs...)\n\nIn addition there are these plot constructors for higher-dimensional plots\n\ncontour\nheatmap\nsurface\n\n\n\n\n\n","category":"module"},{"location":"reference/#PlotlyLightLite.annotate!-Tuple{Plot, Any, Any, Any}","page":"Reference/API","title":"PlotlyLightLite.annotate!","text":"annotate!([p::Plot], x, y, txt; [color], [family], [pointsize], [halign], [valign])\nannotate!([p::Plot], anns::Tuple;  kwargs...)\n\nAdd annotations to plot.\n\nx, y, txt: text to add at (x,y)\ncolor: text color\nfamily: font family\npointsize: text size\nhalign: one of \"top\", \"bottom\"\nvalign: one of \"left\", \"right\"\nrotation: angle to rotate\n\nThe x, y, txt values can be specified as 3 iterables or tuple of tuples.\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.circle!-Tuple{Plot, Vararg{Any, 4}}","page":"Reference/API","title":"PlotlyLightLite.circle!","text":"circle([p::Plot], x0, x1, y0, y1; kwargs...)\n\nDraw circle shape bounded in [x0, x1] × [y0,y1]. (Will adjust to non-equal sized boundary.)\n\nExample\n\nUse named tuple for line for boundary.\n\ncircle!(p, 2,3,-1,1; line=(color=:gray,), fillcolor=:red, opacity=0.2)\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.contour-Tuple{Any, Any, Any}","page":"Reference/API","title":"PlotlyLightLite.contour","text":"contour(x, y, z; kwargs...)\ncontour!([p::Plot], x, y, z; kwargs...)\ncontour(x, y, f::Function; kwargs...)\ncontour!(x, y, f::Function; kwargs...)\n\nCreate contour function of f\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.current-Tuple{}","page":"Reference/API","title":"PlotlyLightLite.current","text":"current()\n\nGet current figure. A Plot object of PlotlyLight; UndefRefError if none.\n\nNot typically needed, as it is implicit in most mutating calls, though may be convenient if those happen within a loop.\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.grid_layout-Tuple{Array{<:Plot}}","page":"Reference/API","title":"PlotlyLightLite.grid_layout","text":"grid_layout(ps::Array{<:Plot})\n\nLayout an array of plots into a grid. Vectors become rows of plots.\n\nUse Plot() to create an empty plot for a given cell.\n\nExample\n\nusing DataFrames\nn = 25\nd = DataFrame(x=sin.(rand(n)), y=rand(n).^2, z = rand(n)) # assume all numeric\nnms = names(d)\nm = Matrix{Plot}(undef, length(nms), length(nms))\n\nfor i ∈ eachindex(nms)\n    for j ∈ eachindex(nms)\n        if j > i\n            p = Plot()\n        elseif j == i\n            x = d[:,j]\n            p = plot(x, type=\"histogram\")\n            xlabel!(p, nms[j])  # <<- not working in grid! as differe xaxis purposes\n        else\n            x = d[:,i]; y = d[:,j]\n            p = scatter(x, y)\n            xlabel!(p, nms[i]); ylabel!(p, nms[j])\n        end\n        m[i,j] = p\n    end\nend\ngrid_layout(m)\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.heatmap-Tuple{Any, Any, Any}","page":"Reference/API","title":"PlotlyLightLite.heatmap","text":"heatmap(x, y, z; kwargs...)\nheatmap!([p::Plot], x, y, z; kwargs...)\nheatmap(x, y, f::Function; kwargs...)\nheatmap!(x, y, f::Function; kwargs...)\n\nCreate heatmap function of f\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.legend!","page":"Reference/API","title":"PlotlyLightLite.legend!","text":"legend!([p::Plot], legend::Bool) hide/show legend\n\n\n\n\n\n","category":"function"},{"location":"reference/#PlotlyLightLite.plot!-Tuple{Plot, Any, Any}","page":"Reference/API","title":"PlotlyLightLite.plot!","text":"plot!([p::Plot], x, y; kwargs...)\nplot!([p::Plot], f, a, [b]; kwargs...)\nplot!([p::Plot], f; kwargs...)\n\nUsed to add a new tract to an existing plot. Like Plots.plot!. See plot for argument details.\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.plot-Tuple{Any, Vararg{Any}}","page":"Reference/API","title":"PlotlyLightLite.plot","text":"plot(x, y, [z]; [linecolor], [linewidth], [legend], kwargs...)\nplot(f::Function, a, [b]; kwargs...)\n\nCreate a line plot.\n\nReturns a Plot instance from PlotlyLight\n\nx,y points to plot. NaN values in y break the line\na, b: the interval to plot a function over can be given by two numbers or if just a then by extrema(a).\nlinecolor: color of line\nlinewidth: width of line\nlabel in legend\n\nOther keyword arguments include width and height, xlims and ylims, legend, aspect_ratio.\n\nProvides an interface like Plots.plot for plotting a function f using PlotlyLight. This just scratches the surface, but PlotlyLight allows full access to the underlying JavaScript library library.\n\nThe provided \"Plots-like\" functions are plot, plot!, scatter!, scatter, annotate!,  title!, xlims! and ylims!.\n\nExample\n\np = plot(sin, 0, 2pi; legend=false)\nplot!(cos)\n# add points\nx0 = [pi/4, 5pi/4]\nscatter!(x0, sin.(x0), markersize=10)\n# add text\nannotate!(tuple(zip(x0, sin.(x0), (\"A\", \"B\"))...), halign=\"left\", pointsize=12)\ntitle!(\"Sine and cosine and where they intersect in [0,2π]\")\n# adjust limits\nylims!((-3/2, 3/2))\n# add shape\ny0, y1 = extrema(p).y\n[rect!(xᵢ-0.1, xᵢ+0.1, y0, y1, fillcolor=\"gray\", opacity=0.2) for xᵢ ∈ x0]\n# display plot\np\n\nnote: Warning\nYou may need to run the first plot cell twice to see an image.\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.plot-Tuple{}","page":"Reference/API","title":"PlotlyLightLite.plot","text":"plot(; layout::Config?, config::Config?, kwargs...)\n\nPass keyword arguments through Config and onto PlotlyLight.Plot.\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.plot-Union{Tuple{N}, Tuple{Tuple{Vararg{Function, N}}, Any}, Tuple{Tuple{Vararg{Function, N}}, Any, Any}} where N","page":"Reference/API","title":"PlotlyLightLite.plot","text":"plot((f,g), a, b; kwargs...)\nplot!([p::PLot], (f,g), a, b; kwargs...)\n\nMake parametric plot from tuple of functions, f and g.\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.quiver!","page":"Reference/API","title":"PlotlyLightLite.quiver!","text":"quiver!([p::Plot], x, y, txt=nothing; quiver=(dx, dy), kwargs...)\nquiver(x, y, txt=nothing; quiver=(dx, dy), kwargs...)\n\n(x,y) are tail positions, optionally labeled by txt\nquiver specifies vector part of arrow\nkwargs processarrowhead::Int?,arrowwidth::Int?,arrowcolor`\n\nExample\n\nts = range(0, 2pi, length=100)\np = plot(sin.(ts), cos.(ts), linecolor=\"red\")\nts = range(0, 2pi, length=10)\nquiver!(p, cos.(ts), sin.(ts), quiver=(-sin.(ts), cos.(ts)), arrowcolor=\"red\")\np\n\nThis example shows how text can be rotated with angles in degrees and positive angles measured in a clockwise direction.\n\nts = range(0, 2pi, 100)\np = plot(cos.(ts), sin.(ts), linecolor=\"red\", aspect_ratio=:equal,\n    linewidth=20, opacity=0.2)\n\ntxt = split(\"The quick brown fox jumped over the lazy dog\")\nts = range(0, 360, length(txt)+1)[2:end]\nfor (i,t) ∈ enumerate(reverse(ts))\n    quiver!(p, [cosd(t)],[sind(t)],txt[i],\n            quiver=([0],[0]),\n            textangle=90-t,\n            font=(size=20,))\nend\nxaxis!(zeroline=false); yaxis!(zeroline=false) # remove zerolines\np\n\n\n\n\n\n","category":"function"},{"location":"reference/#PlotlyLightLite.rect!-Tuple{Plot, Vararg{Any, 4}}","page":"Reference/API","title":"PlotlyLightLite.rect!","text":"rect!([p::Plot], x0, x1, y0, y1; kwargs...)\n\nDraw rectangle shape.\n\nExample\n\nUse named tuple for line for boundary.\n\nrect!(p, 2,3,-1,1; line=(color=:gray,), fillcolor=:red, opacity=0.2)\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.scatter!-Tuple{Plot, Any, Any}","page":"Reference/API","title":"PlotlyLightLite.scatter!","text":"scatter(x, y, [z]; [markershape], [markercolor], [markersize], kwargs...)\nscatter!([p::Plot], x, y, [z]; kwargs...)\n\nPlace point on a plot.\n\nmarkershape: shape, e.g. \"diamond\" or \"diamond-open\"\nmarkercolor: color e.g. \"red\"\nmarkersize:  size, as an integer\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.scatter-Tuple{Any, Vararg{Any}}","page":"Reference/API","title":"PlotlyLightLite.scatter","text":"scatter(x, y; kwargs...) see scatter!\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.scroll_zoom!-Tuple{Plot, Bool}","page":"Reference/API","title":"PlotlyLightLite.scroll_zoom!","text":"scrollzoom!([p], x::Bool) turn on/off scrolling to zoom\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.size!-Tuple{Plot}","page":"Reference/API","title":"PlotlyLightLite.size!","text":"size!([p::Plot]; [width], [height]) specify size of plot figure\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.surface-Tuple{Any, Any, Any}","page":"Reference/API","title":"PlotlyLightLite.surface","text":"surface(x, y, z; kwargs...)\nsurface!(x, y, z; kwargs...)\nsurface(x, y, f::Function; kwargs...)\nsurface!(x, y, f::Function; kwargs...)\n\nCreate surface plot. Pass zcontour=true to add contour plot projected onto the z axis.\n\nExample\n\nFrom https://discourse.julialang.org/t/3d-surfaces-time-slider/109673\n\nz1 = Vector[[8.83, 8.89, 8.81, 8.87, 8.9, 8.87],\n                       [8.89, 8.94, 8.85, 8.94, 8.96, 8.92],\n                       [8.84, 8.9, 8.82, 8.92, 8.93, 8.91],\n                       [8.79, 8.85, 8.79, 8.9, 8.94, 8.92],\n                       [8.79, 8.88, 8.81, 8.9, 8.95, 8.92],\n                       [8.8, 8.82, 8.78, 8.91, 8.94, 8.92],\n                       [8.75, 8.78, 8.77, 8.91, 8.95, 8.92],\n                       [8.8, 8.8, 8.77, 8.91, 8.95, 8.94],\n                       [8.74, 8.81, 8.76, 8.93, 8.98, 8.99],\n                       [8.89, 8.99, 8.92, 9.1, 9.13, 9.11],\n                       [8.97, 8.97, 8.91, 9.09, 9.11, 9.11],\n                       [9.04, 9.08, 9.05, 9.25, 9.28, 9.27],\n                       [9, 9.01, 9, 9.2, 9.23, 9.2],\n                       [8.99, 8.99, 8.98, 9.18, 9.2, 9.19],\n                       [8.93, 8.97, 8.97, 9.18, 9.2, 9.18]]\nxs , ys = 1:length(z1[1]), 1:length(z1) # needed here given interface chosen\nsurface(xs, ys, z1, colorscale=\"Viridis\")\nsurface!(xs, ys, map(x -> x .+ 1, z1), colorscale=\"Viridis\", showscale=false, opacity=0.9)\nsurface!(xs, ys, map(x -> x .- 1, z1), colorscale=\"Viridis\", showscale=false, opacity=0.9)\n\nJulia users would typically use a matrix to hold the z data, but Javascript users would expect a vector of vectors, as above. As PlotlyLight just passes on the data to Javascript, the above is perfectly acceptable. (The keyword arguments above come from Plotly, not Plots.)\n\nA parameterized surface can be displayed. Below the unzip function returns 3 matrices specifying the surface described by the vector-valued function r.\n\nr1, r2 = 2, 1/2\nr(u,v) = ((r1 + r2*cos(v))*cos(u), (r1 + r2*cos(v))*sin(u), r2*sin(v))\nus = vs = range(0, 2pi, length=25)\nxs, ys, zs = unzip(us, vs, r)\n\nsurface(xs, ys, zs)\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.title!-Tuple{Plot, Any}","page":"Reference/API","title":"PlotlyLightLite.title!","text":"title!([p::Plot], txt)\n\nSet plot title.\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.unzip-Tuple{Any}","page":"Reference/API","title":"PlotlyLightLite.unzip","text":"unzip(v, [vs...])\nunzip(f::Function, a, b)\nunzip(a, b, F::Function)\n\nReshape data to x,y,[z] mode.\n\nIn its basic use, zip takes two vectors, pairs them off, and returns an iterator of tuples for each pair. For unzip a vector of same-length vectors is \"unzipped\" to return two (or more) vectors.\n\nThe function version applies f to a range of points over (a,b) and then calls unzip. This uses the adapted_grid function from PlotUtils.\n\nThe function version with F computes F(a', b) and then unzips. This is used with parameterized surface plots\n\nThis uses the invert function of SplitApplyCombine.\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.xaxis!-Tuple{Plot}","page":"Reference/API","title":"PlotlyLightLite.xaxis!","text":"xticks!([p::Plot]; kwargs...)\nyticks!([p::Plot]; kwargs...)\n\nAdjust ticks on chart.\n\nticks: a container or range\nticklabels: optional labels (same length as ticks)\nshowticklabels::Bool\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.xlims!-Tuple{Plot, Any}","page":"Reference/API","title":"PlotlyLightLite.xlims!","text":"xlims!(p, lims) set x limits of plot\n\n\n\n\n\n","category":"method"},{"location":"reference/#PlotlyLightLite.ylims!-Tuple{Plot, Any}","page":"Reference/API","title":"PlotlyLightLite.ylims!","text":"ylims!(p, lims) set y limits of plot\n\n\n\n\n\n","category":"method"},{"location":"#PlotlyLightLite.jl","page":"Home","title":"PlotlyLightLite.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for PlotlyLightLite, a package to give Plots-like access to PlotlyLight for the graphs of Calculus.","category":"page"},{"location":"","page":"Home","title":"Home","text":"This package provides a light-weight alternative to Plots.jl which utilizes basically a subset of the Plots interface. It is inspired by SimplePlots and is envisioned as being useful within resource-constrained environments such as binder.org.","category":"page"},{"location":"","page":"Home","title":"Home","text":"using PlotlyLightLite\nusing PlotlyDocumenter # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"The plotting interface provided picks some of the many parts of Plots.jl that prove useful for the graphics of calculus and provides a stripped-down, though reminiscent interface using PlotlyLight, a package which otherwise is configured in a manner very-much like the underlying JavaScript implementation. The Plots package is great – and has Plotly as a backend – but for resource-constrained usage can be too demanding.","category":"page"},{"location":"#Supported-plotting-functions","page":"Home","title":"Supported plotting functions","text":"","category":"section"},{"location":"#plot","page":"Home","title":"plot","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The simplest means to plot a function f over the interval [a,b] is the pattern plot(f, a, b). For example:","category":"page"},{"location":"","page":"Home","title":"Home","text":"plot(sin, 0, 2pi)\n\ndelete!(current().layout, :width)  # hide\ndelete!(current().layout, :height) # hide\nto_documenter(current())           # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"The sin object refers to a the underlying function to compute sine. More commonly, the function is user-defined as f, or some such, and that function object is plotted. The interval may be specified using two numbers or with a container, in which case the limits come from calling extrema.","category":"page"},{"location":"#plot!","page":"Home","title":"plot!","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Layers can be added to a basic plot. The notation follows Plots.jl and uses Julia's convention of indicating functions which mutate their arguments with a !. The underlying plot is mutated (by adding a layer) and reference to this may or may not be in the plot! call. (When missing, the current plotting figure, determined by current(), is used.)","category":"page"},{"location":"","page":"Home","title":"Home","text":"plot(sin, 0, 2pi)\n\nplot!(cos)    # no limits needed, as they are computed from the current figure\n\nplot!(x -> x, 0, pi/2)      # limits can be specified\nplot!(x -> 1 - x^2/2, 0, pi/2)\n\ndelete!(current().layout, :width)  # hide\ndelete!(current().layout, :height) # hide\nto_documenter(current())           # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"As a convenience, a vector of functions can be passed in. In which case, each is plotted over the interval. The keyword arguments are passed to the first function only. For more control, using plot!, as above.","category":"page"},{"location":"#plot(x,-y).","page":"Home","title":"plot(x, y).","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The plot(x, y) function simply connects the points (x_1y_1) (x_2y_2)dots  with a line in a dot-to-dot manner (the lineshape argument can modify this). If values in y are non finite, then a break in the dot-to-dot graph is made.","category":"page"},{"location":"","page":"Home","title":"Home","text":"When plot is passed a  function in the first argument, the x-y values are created by unzip(f, a, b) which uses an adaptive algorithm from PlotUtils.","category":"page"},{"location":"#scatter","page":"Home","title":"scatter","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Related to plot and plot! is scatter (and scatter!) which plots just the points, but has no connecting dots. The marker shape, size, and color can be adjusted by keyword arguments.","category":"page"},{"location":"#Text-and-arrows","page":"Home","title":"Text and arrows","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The annotate! and quiver! functions are used to add text and/or arrows","category":"page"},{"location":"#Shapes","page":"Home","title":"Shapes","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"For basic shapes there are hline!, vline!, rect!. and circle!.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"For example, this shows how one could visualize the points chosen in a plot, showcasing both plot and scatter! in addition to a few other plotting commands:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using Roots\n\nf(x) = x^2 * (108 - 2x^2)/4x\nx, y = unzip(f, 0, sqrt(108/2))\nplot(x, y; legend=false)\nscatter!(x, y, markersize=10)\n\nquiver!([2,4.3,6],[10,50,10], [\"sparse\",\"concentrated\",\"sparse\"],\n        quiver=([-1,0,1/2],[10,15,5]))\n\n# add rectangles to emphasize plot regions\ny0, y1 = extrema(current()).y  # get extent in `y` direction\nrect!(0, 2.5, y0, y1, fillcolor=\"#d3d3d3\", opacity=0.2)\nrect!(2.5,6, y0, y1, line=(color=\"black\",), fillcolor=\"orange\", opacity=0.2)\nrect!(6, find_zero(f, 7), y0, y1, fillcolor=\"rgb(150,150,150)\", opacity=0.2)\n\ndelete!(current().layout, :width)  # hide\ndelete!(current().layout, :height) # hide\nto_documenter(current())           # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"The values returned by unzip(f,a, b) are not uniformly chosen, rather where there is more curvature there is more sampling. For illustration purposes, this is emphasized in a few ways: using quiver! to add labeled arrows and rect! to add rectangular shapes with transparent filling.","category":"page"},{"location":"#Other-graphs","page":"Home","title":"Other graphs","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Parametric plots can be easily created by using a tuple of functions, as in:","category":"page"},{"location":"","page":"Home","title":"Home","text":"plot((sin, cos, x -> x), 0, 4pi)\n\ndelete!(current().layout, :width)  # hide\ndelete!(current().layout, :height) # hide\nto_documenter(current())           # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"Contour, heatmaps, and surface plots can be produced by contour, heatmap, and surface. This example uses the peaks function of MATLAB:","category":"page"},{"location":"","page":"Home","title":"Home","text":"function peaks(x,y)\n\tz = 3*(1-x)^2* exp(-(x.^2) - (y+1)^2)\n\tz = z - 10*(x/5 - x^3 - y^5) * exp(-x^2-y^2)\n    z = z - 1/3*exp(-(x+1)^2 - y^2)\nend\nxs = range(-3, 3, length=100)\nys = range(-2, 2, length=100)\ncontour(xs, ys, peaks)\n\ndelete!(current().layout, :width)  # hide\ndelete!(current().layout, :height) # hide\nto_documenter(current())           # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"surface(xs, ys, peaks)\n\ndelete!(current().layout, :width)  # hide\ndelete!(current().layout, :height) # hide\nto_documenter(current())           # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"Parametric surfaces can be produced as follows, where unzip creates 3 matrices to pass to surface:","category":"page"},{"location":"","page":"Home","title":"Home","text":"r1, r2 = 2, 1/2\nr(u,v) = ((r1 + r2*cos(v))*cos(u), (r1 + r2*cos(v))*sin(u), r2*sin(v))\nus = vs = range(0, 2pi, length=25)\nsurface(unzip(us, vs, r)...)\n\ndelete!(current().layout, :width)  # hide\ndelete!(current().layout, :height) # hide\nto_documenter(current())           # hide","category":"page"},{"location":"","page":"Home","title":"Home","text":"note: FIXME\nThe above surface and contour graphics aren't rendering properly in the documentation.","category":"page"},{"location":"#keyword-arguments","page":"Home","title":"keyword arguments","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The are several keyword arguments used to adjust the defaults for the graphic, for example, legend=false and markersize=10. Some keyword names utilize Plots.jl naming conventions and are translated back to their Plotly counterparts. Additional keywords are passed as is so should use the Plotly names.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Some keywords chosen to mirror Plots.jl are:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Argument Used by Notes\nwidth, height new plot calls set figure size, cf. size!\nxlims, ylims new plot calls set figure boundaries, cf xlims!, ylims!, extrema\nlegend new plot calls set or disable legend\naspect_ratio new plot calls set to :equal for equal x-y axes\nlabel plot, plot! set with a name for trace in legend\nlinecolor plot, plot! set with a color\nlinewidth plot, plot! set with an integer\nlinestyle plot, plot! set with \"solid\", \"dot\", \"dash\", \"dotdash\", ...\nlineshape plot, plot! set with \"linear\", \"hv\", \"vh\", \"hvh\", \"vhv\", \"spline\"\nmarkershape scatter, scatter! set with \"diamond\", \"circle\", ...\nmarkersize scatter, scatter! set with integer\nmarkercolor scatter, scatter! set with color\ncolor annotate! set with color\nfamily annotate! set with string (font family)\npointsize annotate! set with integer\nrotation annotate! set with angle, degrees\ncenter new 3d plots set with tuple, see controls\nup new 3d plots set with tuple, see controls\neye new 3d plots set with tuple, see controls","category":"page"},{"location":"","page":"Home","title":"Home","text":"As seen in the example there are many ways to specify a color. These can be by name (as a string); by name (as a symbol), using HEX colors, using rgb (the use above passes a JavaScript command through a string). There are likely more.","category":"page"},{"location":"","page":"Home","title":"Home","text":"One of the rect! calls has a line=(color=\"black\",) specification. This is a keyword argument from Plotly. Shapes have an interior and exterior boundary. The line attribute is used to pass in attributes, in this case the line color is black. A named tuple is used (which is why the trailing comma is needed for this single element tuple).","category":"page"},{"location":"","page":"Home","title":"Home","text":"As seen in this overblown example, there are other methods to plot different things. These include:","category":"page"},{"location":"","page":"Home","title":"Home","text":"scatter! is used to plot points\nannotate! is used to add annotations at a given point. There are keyword arguments to adjust the text size, color, font-family, etc.  There is also quiver which adds arrows and these arrows may have labels. The quiver command allows for text rotation.\nquiver! is used to add arrows to a plot. These can optionally have their tails labeled, so this method can be repurposed to add annotations.\ncontour is used to create contour plots\nsurface is used to plot 3-dimensional surfaces.\nrect! is used to make a rectangle. Plots.jl uses Shape. See also circle!.\nhline! vline! to draw horizontal or vertical lines across the extent of the plotting region","category":"page"},{"location":"","page":"Home","title":"Home","text":"Some exported names are used to adjust a plot after construction:","category":"page"},{"location":"","page":"Home","title":"Home","text":"title!, xlabel!, ylabel!: to adjust title; x-axis label; y-axis label\nxlims!, ylims!: to adjust limits of viewing window\nxaxis!, yaxis!: to adjust the axis properties\nplot to specify a cell-like layout using a matrix of plots.","category":"page"},{"location":"","page":"Home","title":"Home","text":"note: Subject to change\nThere are some names for keyword arguments that should be changed.","category":"page"}]
}
