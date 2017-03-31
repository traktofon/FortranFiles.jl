import Base: close

immutable FortranFile{R<:RecordType}
   io      :: IO    # the underyling I/O stream
   rectype :: R
end

FortranFile(fn::String, mode = "r", rt::RecordType = RECMRKDEF) = FortranFile(open(fn,mode), rt)

close(f::FortranFile) = close(f.io)
rewind(f::FortranFile) = seek(f.io, 0)
