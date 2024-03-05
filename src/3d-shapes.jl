"""
    ★(q, xs, ys, zs; kwargs...)
    ★!([p::Plot], q, xs, ys, zs; kwargs...)

A star connected region has an origin, `q`, for which each boundary point (described by `(xs, ys, zs)` is accessible by a ray for `q` which does not cross the boundary.

## Example

```
pts = 5
Δ = 2pi/pts/2
a, A = 1, 3
q = [0,0,0]
ts = range(0, 2pi, length=pts+1)
ps = [(A*[cos(t),sin(t),0], a*[cos(t+Δ), sin(t+Δ), 0]) for t in ts]
xs, ys, zs = unzip(collect(Base.Iterators.flatten(ps)))
★(q, xs, ys, zs)
```

"""
function ★(q, xs, ys, zs; kwargs...)
    p = _new_plot(; kwargs...)
    ★!(p, q, xs, ys, zs; kwargs...)
end

★!(q, xs, ys, zs; kwargs...) =
    ★!(current_plot[], xs, ys, zs; kwargs...)

function ★!(p::Plot, q, xs, ys, zs; kwargs...)
    x = copy(xs); pushfirst!(x, q[1])
    y = copy(ys); pushfirst!(y, q[2])
    z = copy(zs); pushfirst!(z, q[3])

    n = length(x)
    i = zeros(Int,n-1)
    j = 1:n-1
    k = mod.(1 .+ j, n)

    d = Config(;x,y,z,i,j,k, type="mesh3d", kwargs...)
    push!(p.data, d)
    p
end

"""
    ziptie(xs, ys, zs, xs′, ys′, zs′; kwargs...)
    ziptie!([p::Plot], xs, ys, zs, xs′, ys′, zs′; kwargs...)

Surface created by connecting points along two paths given by `(xs, ys, zs)` and `(xs′, ys′, zs′)`. All vectors must be same length. Mesh is created by zipping together points on the two curves. Makie docs refer to this as a [ruled surface](https://en.m.wikipedia.org/wiki/Ruled_surface).

## Example

```
r(t) = (sin(t), cos(t), t)
s(t) = (sin(t+pi), cos(t+pi), t)
ts = range(0, 4pi, length=100)
ziptie(unzip(r.(ts))..., unzip(s.(ts))...;
       color="green", opacity=.25, showscale=false)
```
"""
function ziptie(xs, ys, zs, xs′, ys′, zs′; kwargs...)
    p = _new_plot(; kwargs...)
    ziptie!(p, xs, ys, zs, xs′, ys′, zs′; kwargs...)
end
ziptie!(xs, ys, zs, xs′, ys′, zs′; kwargs...) =
    ziptie!(current_plot[], xs, ys, zs, xs′, ys′, zs′; kwargs...)

function ziptie!(p::Plot, xs, ys, zs, xs′, ys′, zs′; kwargs...)
    # need to join xs, ys, zs to get x,y,z

    x = collect(Base.Iterators.flatten(zip(xs,xs′)))
    y = collect(Base.Iterators.flatten(zip(ys,ys′)))
    z = collect(Base.Iterators.flatten(zip(zs,zs′)))

    n = length(x)
    iₛ = 0:2:(n-4)
    i = collect(Base.Iterators.flatten(zip(iₛ, iₛ .+ 1)))
    j = i .+ 1
    k = i .+ 2
    d = Config(; x, y, z, i, j, k, type="mesh3d", kwargs...)
    push!(p.data, d)
    p
end

## ----

# a few implementations of shapes: a parallelogram; a disc; a "skirt"
"""
    parallelogram(q, v̄, w̄; kwargs...)
    parallelogram!([p::Plot], q, v̄, w̄; kwargs...)

Plot parallelogram formed by two vectors, `v̄` and `w̄`, both anchored at point `q`.
"""
function parallelogram(q, v̄, w̄; kwargs...)
    p = _new_plot(;kwargs...)
    parallelogram!(p, q, v̄, w̄; kwargs...)
end
parallelogram!(q, v̄, w̄; kwargs...) =
    parallelogram!(current_plot[], q, v̄, w̄; kwargs...)

function parallelogram!(p::Plot, q, v̄, w̄; kwargs...)
    xyzₛ = [q + v̄, q + v̄ + w̄, q + w̄]
    ★!(p, q, unzip(xyzₛ)...; kwargs...)
end

"""
    circ3d(q, r, n̄; kwargs...)
    circ3d!([p::Plot], q, r, n̄; kwargs...)

Plot circle in 3 dimensions with center at `q`, radius `r`, and perpendicular to normal vector `n̄`.

# Example
```
q, n = [0,0,0], [0,0,1]
circ3d(q, 3, n)
arrow!(q, n)
```

Or a more complicated one:

```
Z(r, θ) = 4 - r
X(r, θ) = r * cos(θ)
Y(r, θ) = r * sin(θ)
rs = range(0,4, length=10)
θs = range(0, 2pi, length=100)
surface(X.(rs', θs), Y.(rs', θs), Z.(rs', θs); opacity=0.25)
q = [0,0,2]
n = [0,0,1]
r = 2
circ3d!(q, r, n; color="black", opacity=0.75)
q, v̂, ŵ = [0,0,0], [0,4,0], [0,0,4]
parallelogram!(q, v̂, ŵ; opacity=0.5, color=:yellow)
```
"""
function circ3d(q, r, n̄; kwargs...)
    p = _new_plot(;kwargs...)
    circ3d!(p, q, r, n̄; kwargs...)
end
circ3d!(q, r, n̄; kwargs...) =
    circ3d!(current_plot[], q, r, n̄; kwargs...)

function circ3d!(p::Plot, q, r, n̄; kwargs...)
    _cross = (v,w) -> [v[2]*w[3] - v[3]*w[2], -v[1]*w[3] + v[3]*w[1], v[1]*w[2] - v[2]*w[1]]
    _norm = v -> sqrt(sum(vᵢ^2 for vᵢ∈v))

    n = 100

    v = n̄
    v̂ = v / _norm(v)

    if iszero(v[1]) && iszero(v[2])
        ŵ = [1,0,0]
    else
        w = [v[2],-v[1],0]
        ŵ = w / _norm(w)
    end

    û = _cross(v̂,  ŵ)

    xyzₛ = [q + cos(t) * (r*ŵ)+ sin(t) * (r*û) for t in range(0, 2pi, length=n)]

    ★!(p, q, unzip(xyzₛ)...; kwargs...)
end

"""
    skirt(q, v, f::Function; kwargs...)
    skirt!([p::Plot], q, v, f::Function; kwargs...)
    skirt!([p::Plot], xs, ys, zs, f::Function; kwargs...)

Along a path `(xs, ys, zs)` plot a skirt between the path and `(xs, ys, f(xs, ys))`. The case of a path described by a vector, `v`, anchored at a point `q` has a special method.

## Example
```
x(r, θ) = r*cos(θ)
y(r, θ) = r*sin(θ)
f(x,y) = 4 - x^2 - y^2
rs, θs = range(0,2,length=10), range(0, 2pi, length=20)
xs, ys = x.(rs', θs), y.(rs', θs)
zs = f.(xs, ys)
surface(xs, ys, zs, opacity=.2, showscale=false)

q = [0,0,0]
v = [2,0,0]
d = skirt!(q, v, f; opacity=0.6)

t = range(0, 1, length=100)
xs = 2 * t .* sin.(t*pi/2)
ys = 2 * t .* cos.(t*pi/2)
zs = zero.(xs)
skirt!(xs, ys, zs, f; color="blue", opacity=0.6)
skirt!(xs, -ys, zs, f; color="blue", opacity=0.6)
```

"""
function skirt(q, v, f::Function; kwargs...)
    p = _new_plot(;kwargs...)
    skirt!(p, q, v, f; kwargs...)
end
skirt!(q, v, f::Function; kwargs...) = skirt!(current(), q, v, f; kwargs...)
function skirt!(p::Plot, q, v, f::Function; kwargs...)
    ts = range(0, 1, length=100)
    xs, ys, zs = unzip([q + t*v for t ∈ ts])
    skirt!(p, xs, ys, zs, f; kwargs...)
end

# xs, ys, zs are path in space
function skirt(xs, ys, zs, f::Function; kwargs...)
    p = _new_plot()
    skirt!(p, xs, ys, zs, f)
end
skirt!(xs, ys, zs, f::Function; kwargs...) =
    skirt!(current_plot[], xs, ys, zs, f; kwargs...)

function skirt!(p::Plot, xs, ys, zs, f::Function; kwargs...)
    zs′ = f.(xs, ys)
    ziptie!(p, xs, ys, zs, xs, ys, zs′; kwargs...)
end

# lower, upper contain points
"""
    band(lower, upper; kwargs...)
    band(lower::Function, upper::Function, a::Real, b::Real,n=251; kwargs...)
    band!([p::Plot],lower, upper; kwargs...)
    band!([p::Plot],lower::Function, upper::Function, a::Real, b::Real,n=251; kwargs...)

Draw band between `lower` and `upper`. These may be specified by functions or by tuples of `x-y-[z]` values.

# Example

Using `(x,y)` points to define the boundaries
```
xs = 1:0.2:10
ys_low = -0.2 .* sin.(xs) .- 0.25
ys_high = 0.2 .* sin.(xs) .+ 0.25

p = plot(;xlims=(0,10), ylims=(-1.5, .5), legend=false)
band!(zip(xs, ys_low), zip(xs, ys_high); fillcolor=:blue)
band!(zip(xs, ys_low .- 1), zip(xs, ys_high .- 1); fillcolor=:red)
```

Or, using functions to define the boundaries

```
band(x -> -0.2 * sin(x) - 0.25, x -> 0.2 * sin(x) + 0.25, 0, 10;
     fillcolor=:red, legend=false)
```
"""
function band(lower, upper, args...; kwargs...)
    p = _new_plot(; kwargs...)
    band!(p, lower, upper, args...; kwargs...)
end
band!(lower, upper, args...; kwargs...) =
    band!(current_plot[], lower, upper, args...; kwargs...)

function band!(p::Plot, lower::Function, upper::Function, a::Real, b::Real, n=251; kwargs...)
    ts = range(a, b, length=n)
    ls = lower.(ts)
    us = upper.(ts)
    n = length(first(ls))
    n == 1 && return band!(p, Val(2), zip(ts, ls), zip(ts, us); kwargs...)
    band!(p, Val(n), ls, us; kwargs...)
end

function band!(p::Plot, lower, upper; kwargs...)
    n = length(first(lower))
    band!(p, Val(n), lower, upper; kwargs...)
end

function band!(p::Plot, ::Val{3}, lower, upper; kwargs...)
    ziptie!(p, unzip(lower)..., unzip(upper)...; kwargs...)
end

function band!(p::Plot, ::Val{2}, lower, upper;
               fillcolor=nothing,
               linewidth=nothing,
               linecolor=:black,
               linestyle=nothing,
               kwargs...)

    line=Config()
    !isnothing(linecolor) && (line.color = linecolor)
    !isnothing(linewidth) && (line.width = linewidth)
    !isnothing(linestyle) && (line.style = linestyle)

    x,y = unzip(collect(lower))
    l1 = Config(;x,y, line, kwargs...)
    x,y = unzip(collect(upper))
    fill = "tonexty"
    l2 = Config(;x,y, fill, fillcolor, line, kwargs...)
    append!(p.data, (l1, l2))
    p
end
