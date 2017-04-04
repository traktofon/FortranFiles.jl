using FortranFiles
using Base.Test

# To test long records being split into subrecords, without needing
# test data files of several GB, define a custom RecordMarkerType with
# a short maximum subrecord length
const maxsubreclen = 2^15 - 9
const RECMRK4Bwssr = FortranFiles.WithSubrecords(maxsubreclen)
const RECMRK4Bwosr = FortranFiles.WithoutSubrecords{Int32}()

# --- Definition of different types of record marker ---

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

# --- Generation of test data and Julia reading/writing code ---

function gendata(tag, fflags)
   cmd = `make -C codegen SUFFIX=$tag XFLAGS=$fflags`
   run(cmd)
   cmd = `codegen/gendata$(tag).x data$(tag).bin`
   run(cmd)
end

function genalldata(tests)
   for test in tests
      gendata(test.tag, test.fflags)
   end
   return nothing
end

genalldata(recmrktyp_tests)

include("codegen/jread.jl")
include("codegen/jskip.jl")
include("codegen/jwrite.jl")

# --- Auxiliary functions ---

function cmpfiles(a::String, b::String)
   cmd = `cmp $a $b`
   try
      run(cmd)
      return true
   catch
      return false
   end
end

# --- TESTING STARTS HERE ---

@testset "Strings" begin
   jstr = "Hello World!"
   N    = length(jstr)
   fstr = FString(N, jstr)
   @test typeof(fstr) == FString{N}
   @test trimstring(fstr) == jstr
   fstr = FString(80, jstr)
   @test typeof(fstr) == FString{80}
   @test trimstring(fstr) == jstr
   fstr = FString(8, jstr)
   @test typeof(fstr) == FString{8}
   @test trimstring(fstr) == jstr[1:8]
   jstr = "Hällo Wörld!"
   @test_throws InexactError FString(80, jstr)
end


@testset "Tests with record markers of $(test.desc)" for test in recmrktyp_tests

   local infile, outfile, data
   infilename  = "data$(test.tag).bin"
   outfilename = "chck$(test.tag).bin"

   @testset "Opening files" begin
      infile  = FortranFile(infilename, "r", marker = test.recmrktyp)
      @test infile.acctyp.recmrktyp == test.recmrktyp
      outfile = FortranFile(outfilename, "w", marker = test.recmrktyp)
      @test outfile.acctyp.recmrktyp == test.recmrktyp
   end

   @time @testset "Reading data" begin
      data = readdata(infile)
   end

   @time @testset "Reading data with skipping" begin
      rewind(infile)
      skipdata(infile)
      close(infile)
   end

   @time @testset "Writing data" begin
      writedata(outfile, data)
      close(outfile)
   end

   @testset "Verifying data" begin
      @test cmpfiles(infilename, outfilename)
   end

end;
