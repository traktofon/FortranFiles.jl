@compat abstract type RecordType end
@compat abstract type Record<:IO end

immutable RecordTypeSimple{T} <: RecordType end

const RECMRK32 = RecordTypeSimple{Int32}()
const RECMRK64 = RecordTypeSimple{Int64}()

immutable RecordTypeFlexible <: RecordType
   max_subrecord_length :: Int
end

const max_subrecord_length = 2^31-9
const RECMRKFL = RecordTypeFlexible(max_subrecord_length)

const RECMRKDEF = RECMRKFL
