import Base: close, unsafe_read, unsafe_write


immutable RecordTypeSimple{T} <: RecordType end

const REC32 = RecordTypeSimple{Int32}()
const REC64 = RecordTypeSimple{Int64}()


type RecordSimple{T} <: Record
   io       :: IO    # underlying I/O stream
   reclen   :: T     # length of this record
   nleft    :: T     # bytes left in this record
   writable :: Bool  # whether this record is writable
end

function Record{T}( f::FortranFile{RecordTypeSimple{T}} )
## constructor for readable records
   reclen = read(f.io, T)
   RecordSimple{T}(f.io, reclen, reclen, false)
end

function Record{T}( f::FortranFile{RecordTypeSimple{T}}, towrite::Integer )
## constructor for writable records
   write(f.io, convert(T, towrite))
   RecordSimple{T}(f.io, towrite, towrite, true)
end

function unsafe_read( rec::RecordSimple, p::Ptr{UInt8}, n::UInt )
   if (n > rec.nleft); error("attempting to read beyond record end"); end
   unsafe_read( rec.io, p, n )
   rec.nleft -= n
   nothing
end

function unsafe_write( rec::RecordSimple, p::Ptr{UInt8}, n::UInt )
   if (n > rec.nleft); error("attempting to write beyond record end"); end
   nwritten = unsafe_write( rec.io, p, n )
   rec.nleft -= n
   return nwritten
end

function close{T}( rec::RecordSimple{T} )
   if rec.writable
      if rec.nleft != 0; error("record has not yet been completely written"); end
      write(rec.io, convert(T, rec.reclen))
   else
      skip(rec.io, rec.nleft)
      reclen = read(rec.io, T)
      if reclen != rec.reclen; error("trailing record marker doesn't match"); end
   end
   nothing
end

