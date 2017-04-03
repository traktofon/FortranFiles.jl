import Base: show

@compat abstract type AccessMode end
@compat abstract type RecordMarkerType end
@compat abstract type Record<:IO end


immutable SequentialAccess{RT<:RecordMarkerType} <: AccessMode
   recmrktyp :: RT
end

show(io::IO, a::SequentialAccess) =
   print(io, "sequential-access, ", a.recmrktyp)


immutable WithoutSubrecords{T} <: RecordMarkerType
end

const RECMRK8B = WithoutSubrecords{Int64}()

show{T}(io::IO, ::WithoutSubrecords{T}) = 
   print(io, "$(sizeof(T))-byte record markers, no subrecords")


immutable WithSubrecords <: RecordMarkerType
   max_subrecord_length :: Int
end

const max_subrecord_length = 2^31-9
const RECMRK4B = WithSubrecords(max_subrecord_length)

const RECMRKDEF = RECMRK4B

show(io::IO, rt::WithSubrecords) =
   print(io, "4-byte record markers, subrecords of max $(rt.max_subrecord_length) bytes")

