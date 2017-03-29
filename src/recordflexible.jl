import Base: close, unsafe_read, unsafe_write

type RecordFlexible <: Record
   io        :: IO      # underlying I/O stream
   maxsrlen  :: Int32   # maximum subrecord length
   subreclen :: Int32   # length of current subrecord
   subleft   :: Int32   # bytes left in current subrecord
   more      :: Bool    # whether more subrecords will follow
   writable  :: Bool    # whether this record is writable
   isfirst   :: Bool    # if writable: whether this is the first subrecord
   totleft   :: Int64   # if writable: bytes left in this record
end

function rdmarker(io)
   reclen = read(io, Int32)
   more = (reclen < 0)
   return (abs(reclen), more)
end

function mkmarker(towrite, msl)
   subreclen = min(towrite, msl)
   more = (subreclen < towrite)
   return (subreclen, more)
end

function wrmarker(io, subreclen, sign)
   marker = subreclen * (sign? -1: 1)
   write(io, convert(Int32, marker))
end

function Record( f::FortranFile{RecordTypeFlexible} )
## constructor for readable records
   msl = f.rectype.max_subrecord_length
   subreclen, more = rdmarker(f.io)
   RecordFlexible(f.io, msl, subreclen, subreclen, more, false, false, 0)
end

function Record( f::FortranFile{RecordTypeFlexible}, towrite::Integer )
## constructor for writable records
   msl = f.rectype.max_subrecord_length
   subreclen, more = mkmarker(towrite, msl)
   wrmarker(f.io, subreclen, more)
   RecordFlexible(f.io, msl, subreclen, subreclen, more, true, true, towrite)
end

function advance!( rec::RecordFlexible )
   subreclen, sign = rdmarker(rec.io)
   if subreclen != rec.subreclen; error("trailing subrecord marker doesn't match"); end
   if rec.more
      subreclen, more = rdmarker(rec.io)
      rec.subleft = rec.subreclen = subreclen
      rec.more = more
   end
   nothing
end

function unsafe_read( rec::RecordFlexible, p::Ptr{UInt8}, n::UInt )
   while (n>0)
      if rec.subleft==0; error("attempting to read beyond record end"); end
      toread = min(n, rec.subleft)
      unsafe_read(rec.io, p, toread)
      p += toread
      n -= toread
      rec.subleft -= toread
      if rec.subleft==0; advance!(rec); end
   end
   nothing
end

function unsafe_write( rec::RecordFlexible, p::Ptr{UInt8}, n::UInt )
   nwritten = 0
   while (n>0)
      if rec.totleft==0; error("attempting to write beyond record end"); end
      towrite = min(n, rec.subleft)
      nwritten += unsafe_write(rec.io, p, towrite)
      p += towrite
      n -= towrite
      rec.subleft -= towrite
      rec.totleft -= towrite
      if rec.subleft==0
         # the current subrecord is full
         # write trailing subrecord marker
         wrmarker(rec.io, rec.subreclen, !rec.isfirst)
         if rec.more
            # write leading subrecord marker
            subreclen, more = mkmarker(rec.totleft, rec.maxsrlen)
            wrmarker(rec.io, subreclen, more)
            # update our Record
            rec.subleft = rec.subreclen = subreclen
            rec.more = more
            rec.isfirst = false
         end
      end
   end
   return nwritten
end

function close( rec::RecordFlexible )
   if rec.writable
      @assert rec.totleft == 0
      @assert rec.subleft == 0
      @assert !rec.more
   else
      while rec.subleft > 0
         skip(rec.io, rec.subleft)
         advance!(rec)
      end
      @assert !rec.more
   end
   nothing
end

