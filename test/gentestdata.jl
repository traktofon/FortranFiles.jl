include("common.jl")

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
