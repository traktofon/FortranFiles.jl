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
