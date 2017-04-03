@compat abstract type AccessMode end

@compat abstract type RecordMarkerType end

@compat abstract type Record<:IO end


immutable SequentialAccess{RT<:RecordMarkerType} <: AccessMode
   recmrktyp :: RT
end


immutable WithoutSubrecords{T} <: RecordMarkerType
end

const RECMRK8B = WithoutSubrecords{Int64}()


immutable WithSubrecords <: RecordMarkerType
   max_subrecord_length :: Int
end

const max_subrecord_length = 2^31-9
const RECMRK4B = WithSubrecords(max_subrecord_length)

const RECMRKDEF = RECMRK4B
