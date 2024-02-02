module PlotlyLightLite

using PlotlyLight
using PlotUtils


include("utils.jl")
include("plot-utils.jl")
include("plots-lite.jl")

export plot, plot!, scatter, scatter!,  contour, contour!, surface, surface!, quiver, quiver!
export grid_layout
export annotate, annotate!, title!, size!, legend!
export xlabel!, ylabel!, xlims!, ylims!, xaxis!, yaxis!
export rect!, circle!, hline!, vline!
export gcf

end
