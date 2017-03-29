import Base: close

immutable FortranFile{R<:RecordType}
   io      :: IO    # the underyling I/O stream
   rectype :: R
end

FortranFile(fn::String, rt::RecordType, mode="r") = FortranFile(open(fn,mode), rt)

close(f::FortranFile) = close(f.io)
