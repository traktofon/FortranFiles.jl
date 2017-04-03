using FortranFiles

# To test long records being split into subrecords, without needing
# test data files of several GB, define a custom RecordMarkerType with
# a short maximum subrecord length
const maxsubreclen = 2^15 - 9
const RECMRK4Bwssr = FortranFiles.WithSubrecords(maxsubreclen)
const RECMRK4Bwosr = FortranFiles.WithoutSubrecords{Int32}()

immutable RecordMarkerTypeTest
   recmrktyp :: FortranFiles.RecordMarkerType
   desc      :: String
   tag       :: String
   fflags    :: String
end

const recmrktyp_tests = [
   RecordMarkerTypeTest( RECMRK4Bwssr, "4-byte with short subrecords",   "4Bshort", "-fmax-subrecord-length=$(maxsubreclen)" ),
   RecordMarkerTypeTest( RECMRK4B,     "4-byte with default subrecords", "4Bdef",   "" ),
   RecordMarkerTypeTest( RECMRK8B,     "8-byte without subrecords",      "8B",      "-frecord-marker=8" ),
   RecordMarkerTypeTest( RECMRK4Bwosr, "4-byte without subrecords",      "4Bdumb",  "" )
   ]

