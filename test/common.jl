using FortranFiles

# To test long records being split into subrecords, without needing
# test data files of several GB, define a custom RecordType with a
# short maximum subrecord length
const maxsubreclen = 2^15 - 9
const RECMRKSF = FortranFiles.RecordTypeFlexible(maxsubreclen)

immutable RecordTypeTest
   rectype :: FortranFiles.RecordType
   desc    :: String
   tag     :: String
   fflags  :: String
end

const recordtype_tests = [
   RecordTypeTest( RECMRKSF, "short smart 4-byte", "SF", "-fmax-subrecord-length=$(maxsubreclen)" ),
   RecordTypeTest( RECMRKFL, "smart 4-byte", "FL", "" ),
   RecordTypeTest( RECMRK64, "dumb 8-byte", "64", "-frecord-marker=8" ),
   RecordTypeTest( RECMRK32, "dumb 4-byte", "32", "" )
   ]

