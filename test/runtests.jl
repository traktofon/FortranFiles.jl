using FortranFiles
using Base.Test

include("common.jl")

include("codegen/jread.jl")
include("codegen/jskip.jl")
include("codegen/jwrite.jl")

function cmpfiles(a::String, b::String)
   cmd = `cmp $a $b`
   try
      run(cmd)
      return true
   catch
      return false
   end
end


@testset "Tests with $(test.rectype) record markers" for test in recordtype_tests

   local infile, outfile, data
   infilename  = "data$(test.tag).bin"
   outfilename = "chck$(test.tag).bin"

   @testset "Opening files" begin
      infile  = FortranFile(infilename,  "r", test.rectype)
      @test infile.rectype == test.rectype
      outfile = FortranFile(outfilename, "w", test.rectype)
      @test outfile.rectype == test.rectype
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
