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
   written = sum( write(rec,var) for var in vars )
   close(rec)
   return written
end

# workaround for "does not support byte I/O"
function write( rec::Record, var::Int8 )
   write( rec, [var] )
end

check_fortran_type{T}(x::Array{T}) = check_fortran_type(x[1])
check_fortran_type(x::FString) = true
check_fortran_type{T}(x::T) = isbits(T)

function sizeof_var{T}( var::T )
   check_fortran_type(var) || error("cannot serialize datatype $T for Fortran")
   sizeof(var)
end

