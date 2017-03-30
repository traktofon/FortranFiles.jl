using FortranFiles
using Base.Test

const RECSF = FortranFiles.RecordTypeFlexible(2^15-9)

recordtypes = [
   (REC32, "32", "simple 4-byte"),
   (REC64, "64", "simple 8-byte"),
   (RECFL, "FL", "flexible 4-byte"),
   (RECSF, "SF", "short flexible 4-byte") ]

@testset "Tests with $(rectyp) records" for (rectyp, tag, desc) in recordtypes
   infilename  = "data$(tag).bin"
   outfilename = "check$(tag).bin"
   infile  = FortranFile(infilename,  "r", rectyp)
   outfile = FortranFile(outfilename, "w", rectyp)
end
