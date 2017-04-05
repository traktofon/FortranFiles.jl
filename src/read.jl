import Base: read

"""
    read(f::FortranFile [, spec [, spec [, ...]]])

Read data from a `FortranFile`. Like the READ statement in Fortran, this
reads a completely record, regardless of how man `spec`s are given. Each
`spec` can be:
* a `DataType` for scalar values; e.g. `Int32`, `Float64`, `FString{10}`
* a tuple of `DataType` and one or more integers, for reading arrays of
  the given size; e.g. `(Int32,4,2)` reads an `Array{Int32}(4,2)`
* a tuple of `DataType` and a tuple of integers, as an alternative way
  of reading arrays; e.g. `(Int32,(4,2))` does the same as the previous one
* an array, for reading into pre-allocated arrays; `DataType` and size
  of the array are implied through its Julia type.

Return value:
* if no `spec` is given: nothing (the record is skipped over)
* if one `spec` is given: the scalar or array requested
* if more `spec`s are given: a tuple of the scalars and arrays requested, in order
"""
function read( f::FortranFile )
   rec = Record(f)
   close(rec)
   return nothing
end

function read( f::FortranFile, spec )
   rec = Record(f)
   data = read_spec(rec, spec)
   close(rec)
   return data
end

function read( f::FortranFile, specs... )
   rec = Record(f)
   data = [ read_spec(rec,spec) for spec in specs ]
   close(rec)
   return tuple(data...)
end


# workaround for "does not support byte I/O"
function read_spec( io::Record, spec::Type{Int8} )
   b = read_spec(io, (Int8,1))
   return b[1]
end

function read_spec{T}( io::Record, spec::Type{T} )
   read(io, spec)::T
end

function read_spec{T,N}( io::Record, spec::Array{T,N} )
   read!(io, spec)::Array{T,N}
end

function read_spec{I<:Integer}( io::Record, spec::Tuple{DataType,I} )
   T,n = spec
   read!(io, Array{T}(n))::Array{T,1}
end

function read_spec{N}( io::Record, spec::Tuple{DataType, Vararg{Integer,N}} )
   T = spec[1]
   sz = spec[2:end]
   read!(io, Array{T}(sz...))::Array{T,N}
end

function read_spec{N}( io::Record, spec::Tuple{DataType, Tuple{Vararg{Integer,N}}} )
   T,sz = spec
   read!(io, Array{T}(sz...))::Array{T,N}
end

