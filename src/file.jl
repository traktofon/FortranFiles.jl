import Base: close, show

immutable FortranFile{A<:AccessMode}
   io     :: IO    # the underyling I/O stream
   acctyp :: A
end


"""
    FortranFile(io::IO; kwargs...)

Wrap the given `IO` stream as a `FortranFile` containing Fortran "unformatted"
(i.e. binary) data. The keyword arguments can be:
* `access` for specifying the access mode; a `String` being one of
  * "sequential": sequential access as in Fortran, where records have leading
    and trailing record markers. This is the default.
  * [nothing else at the moment]
* `marker`: for specifying the type of record marker; one of
  * `RECMRK4B`: 4-byte record markers (with support for subrecords) [default]
  * `RECMRK8B`: 8-byte record markers

The returned `FortranFile` can be used with Julia's `read` and `write`
functions. See their documentation for more information.
"""
function FortranFile(io::IO; access = "sequential", marker = RECMRKDEF)
   if access == "sequential"
      acctyp = SequentialAccess(marker)
      return FortranFile(io, acctyp)
   else
      error("unsupported access mode \"$(access)\"")
   end
end


"""
    FortranFile(fn::String [, mode="r" ]; kwargs...)

Open a file containing Fortran unformatted (i.e. binary) data for reading
or writing, depending on `mode` which is used as in `open`. The keyword
arguments are as in `FortranFile(io::IO; kwargs...)`.
"""
FortranFile(fn::String, mode = "r"; kwargs...) = FortranFile(open(fn,mode); kwargs...)


"Re-position a `FortranFile` at its beginning."
rewind(f::FortranFile) = seek(f.io, 0)


close(f::FortranFile) = close(f.io)


function show(io::IO, f::FortranFile)
   print(io, "FortranFile(")
   show(io, f.io)
   print(io, "), ")
   show(io, f.acctyp)
end

