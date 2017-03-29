@compat abstract type RecordType end
@compat abstract type Record<:IO end

immutable RecordTypeSimple{T} <: RecordType end

const REC32 = RecordTypeSimple{Int32}()
const REC64 = RecordTypeSimple{Int64}()

immutable RecordTypeFlexible <: RecordType
   max_subrecord_length :: Int
end

const max_subrecord_length = 2^31-9
const RECFL = RecordTypeFlexible(max_subrecord_length)

