using PlotlyLightLite
using Test

@testset "PlotlyLightLite.jl" begin
    u = sin
    a, b = 0, 2pi
    I = (a,b)

    # plots
    p₁ = plot(u, a, b)
    p₂ = plot(u, I)
    p₃ = scatter([1,2, NaN,4], [1,NaN, 3,4])
    grid_layout([p₁ p₂; p₃ Plot()], legend=false)

    p = plot(u, a, b)
    xlims!(p, (1,2))
    ylims!(p, (0, 1))
    title!(p, "plot of u")
    annotate!(p, ((3/2, 1/2, "A"),), pointsize=20)

    @test isa(p, Plot)
    nothing

end
