import Base: close, unsafe_read, unsafe_write

type RecordWithoutSubrecords{T,C} <: Record
   io       :: IO    # underlying I/O stream
   reclen   :: T     # length of this record
   nleft    :: T     # bytes left in this record
   writable :: Bool  # whether this record is writable
   convert  :: C     # convert method
end

function Record{T,C}( f::FortranFile{SequentialAccess{WithoutSubrecords{T}},C} )
## constructor for readable records
   conv = f.convert
   reclen = conv.onread( read(f.io, T) ) # read leading record marker
   RecordWithoutSubrecords{T,C}(f.io, reclen, reclen, false, conv)
end

function Record{T,C}( f::FortranFile{SequentialAccess{WithoutSubrecords{T}},C}, towrite::Integer )
## constructor for writable records
   conv = f.convert
   write(f.io, conv.onwrite( convert(T, towrite) )) # write leading record marker
   RecordWithoutSubrecords{T,C}(f.io, towrite, towrite, true, conv)
end

function unsafe_read( rec::RecordWithoutSubrecords, p::Ptr{UInt8}, n::UInt )
   if (n > rec.nleft); error("attempting to read beyond record end"); end
   unsafe_read( rec.io, p, n )
   rec.nleft -= n
   nothing
end

function unsafe_write( rec::RecordWithoutSubrecords, p::Ptr{UInt8}, n::UInt )
   if (n > rec.nleft); error("attempting to write beyond record end"); end
   nwritten = unsafe_write( rec.io, p, n )
   rec.nleft -= n
   return nwritten
end

function close{T}( rec::RecordWithoutSubrecords{T} )
   if rec.writable
      if rec.nleft != 0; error("record has not yet been completely written"); end
      write(rec.io, rec.convert.onwrite( convert(T, rec.reclen)) ) # write trailing record marker
   else
      skip(rec.io, rec.nleft)
      reclen = rec.convert.onread( read(rec.io, T) ) # read trailing record marker
      if reclen != rec.reclen; error("trailing record marker doesn't match"); end
   end
   nothing
end

