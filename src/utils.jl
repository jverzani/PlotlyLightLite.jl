function _merge!(c::Config; kwargs...)
    for kv ∈ kwargs
        k,v = kv
        v = isa(v,Pair) ? last(v) : v
        isnothing(v) && continue
        c[k] = v
    end
end
function _merge!(c::Config, d::Config)
    for (k, v) ∈ d
        c[k] = v
    end
end


function _join!(xs, delim="")
    xs′ = filter(!isnothing, xs)
    isempty(xs′) && return nothing
    join(string.(xs′), delim)
end

# from some.jl
_something() = nothing
_something(x::Nothing, xs...) = _something(xs...)
_something(x::Any, xs...) = x
# from Missing.jl

_allowmissing(x::AbstractArray{T}) where {T} = convert(AbstractArray{Union{T, Missing}}, x)

## ----
function Base.extrema(p::Plot)
    mx,Mx = (Inf, -Inf)
    my,My = (Inf, -Inf)
    mz,Mz = (Inf, -Inf)
    for d ∈ p.data
        if haskey(d, :x)
            a,b = extrema(d.x)
            mx = min(a, mx); Mx = max(b, Mx)
        end
        if haskey(d, :y)
            a,b = extrema(filter(!isnothing, d.y))
            my = min(a, my); My = max(b, My)
        end
        if haskey(d, :z)
            a,b = extrema(d.z)
            mz = min(a, mz); Mz = max(b, Mz)
        end

    end
    (x = (mx, Mx), y = (my, My), z = (mz, Mz))
end
