import Base: close, unsafe_read, unsafe_write

type FixedLengthRecord{T,C} <: Record
   io       :: IO    # underlying I/O stream
   reclen   :: T     # length of this record
   nleft    :: T     # bytes left in this record
   writable :: Bool  # whether this record is writable
   convert  :: C     # convert method
end

function Record{C}( f::FortranFile{DirectAccess,C} )
## constructor for readable records
   conv = f.convert
   reclen = f.acctyp.reclen
   FixedLengthRecord(f.io, reclen, reclen, false, conv)
end

function Record{C}( f::FortranFile{DirectAccess,C}, towrite::Integer )
## constructor for writable records
   conv = f.convert
   reclen = f.acctyp.reclen
   if towrite > reclen
      error("attempting to write record of $(towrite) bytes into a file of record length $(reclen) bytes")
   end
   FixedLengthRecord(f.io, reclen, reclen, true, conv)
end

function gotorecord( f::FortranFile{DirectAccess}, recnum::Integer )
   reclen = f.acctyp.reclen
   pos = (recnum-1) * reclen
   seek(f.io, pos)
end

function unsafe_read( rec::FixedLengthRecord, p::Ptr{UInt8}, n::UInt )
   if (n > rec.nleft); error("attempting to read beyond record end"); end
   unsafe_read( rec.io, p, n )
   rec.nleft -= n
   nothing
end

function unsafe_write( rec::FixedLengthRecord, p::Ptr{UInt8}, n::UInt )
   if (n > rec.nleft); error("attempting to write beyond record end"); end
   nwritten = unsafe_write( rec.io, p, n )
   rec.nleft -= n
   return nwritten
end

function close( rec::FixedLengthRecord )
   if rec.writable
      # according to the standard, any preceeding data in the record
      # should not be clobbered; but if we are the end of the file,
      # we should pad it to have a complete record.
      if rec.nleft != 0
         if eof(rec.io)
            skip(rec.io, rec.nleft)
            truncate(rec.io, position(rec.io))
         else
            skip(rec.io, rec.nleft)
         end
      end
   else
      skip(rec.io, rec.nleft)
   end
   nothing
end

