import Base: close

immutable FortranFile{R<:RecordType}
   io      :: IO    # the underyling I/O stream
   rectype :: R
end

"""
    FortranFile(fn::String [, mode="r" [, recordtype ]])

Open a file containg Fortran unformatted (i.e. binary) data for reading
or writing, depending on `mode` which is used as in `open`. The optional
argument `recordtype` specifies which kind of record markers the file
uses, one of:
* `RECMRKDEF`: 4-byte record markers (with support for subrecords) [default]
* `RECMRK64`: 8-byte record markers

The returned `FortranFile` can be used with Julia's `read` and `write`
functions. See their documentation for more information.
"""
FortranFile(fn::String, mode = "r", rt::RecordType = RECMRKDEF) = FortranFile(open(fn,mode), rt)

"Re-position a FortranFile at its beginning."
rewind(f::FortranFile) = seek(f.io, 0)

close(f::FortranFile) = close(f.io)
