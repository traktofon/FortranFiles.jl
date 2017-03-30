import Base: write

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

