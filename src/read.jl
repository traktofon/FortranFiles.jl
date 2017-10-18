import Base: read

"""
    read(f::FortranFile [, spec [, spec [, ...]]])
    read(f::FortranFile, rec=N, [, spec [, spec [, ...]]])

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

For direct-access files, the number of the record to be read must be
specified with the `rec` keyword (N=1 for the first record).

Return value:
* if no `spec` is given: nothing (the record is skipped over)
* if one `spec` is given: the scalar or array requested
* if more `spec`s are given: a tuple of the scalars and arrays requested, in order
"""
function read( f::FortranFile, specs...)
   fread(f, specs...)
end

function read( f::FortranFile{DirectAccess}, specs... ; rec::Integer=0 )
   if rec == 0
      error("direct-access files require specifying the record to be read (use rec keyword argument)")
   end
   gotorecord(f, rec)
   fread( f, specs... )
end

function fread( f::FortranFile )
   rec = Record(f)
   close(rec)
   return nothing
end

function fread( f::FortranFile, spec )
   rec = Record(f)
   data = read_spec(rec, spec)
   close(rec)
   return data
end

function fread( f::FortranFile, specs... )
   rec = Record(f)
   data = map( spec->read_spec(rec,spec), specs)
   close(rec)
   return data
end

# workaround for "does not support byte I/O"
function read_spec( rec::Record, spec::Type{Int8} )
   b = read_spec(rec, (Int8,1))
   return b[1]
end

function read_spec( rec::Record, spec::Type{T} ) where {T}
   rec.convert.onread( read(rec, spec) )::T
end

function read_spec( rec::Record, spec::Array{T,N} ) where {T,N}
   arr = read!(rec, spec)::Array{T,N}
   map!(rec.convert.onread, arr, arr)
   return arr
end

function read_spec(rec::Record, spec::Tuple{DataType,I} ) where {I<:Integer}
   T,n = spec
   read_spec(rec, Array{T}(n))::Array{T,1}
end

function read_spec( rec::Record, spec::Tuple{DataType, Vararg{Integer,N}} ) where {N}
   T = spec[1]
   sz = spec[2:end]
   read_spec(rec, Array{T}(sz...))::Array{T,N}
end

function read_spec( rec::Record, spec::Tuple{DataType, Tuple{Vararg{Integer,N}}} ) where {N}
   T,sz = spec
   read_spec(rec, Array{T}(sz...))::Array{T,N}
end

