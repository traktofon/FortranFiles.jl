import Base: write

"""
    write(f::FortranFile, items...)

Write a data record to a `FortranFile`. Each `item` should be a scalar
of a Fortran-compatible datatype (e.g. `Int32`, `Float64`, `FString{10}`),
or an array of such scalars. If no `item`s are given, an empty record is
written. Returns the number of bytes written, **not** including the space
taken up by the record markers.
"""
function write( f::FortranFile )
   rec = Record(f, 0)
   close(rec)
   return 0
end

function write( f::FortranFile, vars... )
   # how much data to write?
   towrite = sum( sizeof_var(var) for var in vars )
   rec = Record(f, towrite)
   written = sum( write_var(rec,var) for var in vars )
   close(rec)
   return written
end

# workarounds for "does not support byte I/O"
function write_var( rec::Record, var::Int8 )
   write_var( rec, [var] )
end

function write_var{N}( rec::Record, arr::Array{Int8,N} )
   write(rec, arr)
end

# write scalars
function write_var{T}( rec::Record, var::T )
   write( rec, rec.convert.onwrite(var) )
end

# write arrays
function write_var{T,N}( rec::Record, arr::Array{T,N} )
   written = 0
   for x in arr
      written += write(rec, rec.convert.onwrite(x))
   end
   return written
end

check_fortran_type{T}(x::Array{T}) = check_fortran_type(x[1])
check_fortran_type(x::FString) = true
check_fortran_type{T}(x::T) = isbits(T)

function sizeof_var{T}( var::T )
   check_fortran_type(var) || error("cannot serialize datatype $T for Fortran")
   sizeof(var)
end

