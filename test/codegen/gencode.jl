import FortranFiles: FString
import Base: size

immutable CodegenTask
   jtype :: DataType
   ftype :: String
   sz    :: Dims
   var   :: String
end

size(task::CodegenTask) = sizeof(task.jtype) * prod(task.sz)

function fdecl(task::CodegenTask)
   if task.sz == (1,)
      code = "$(task.ftype) :: $(task.var)"
   else
      code = "$(task.ftype), allocatable :: $(task.var)("
      code *= join( (":" for _ in task.sz), "," ) * ")"
   end
   return code
end

function fmkdata(task::CodegenTask)
   codes = String[]
   if task.sz != (1,)
      dims = join( ("$dim" for dim in task.sz), "," )
      push!(codes, "allocate($(task.var)($dims))")
   end
   push!(codes, "call random($(task.var))")
   return codes
end

function fwrdata(tasks::Vector{CodegenTask})
   vars = join((task.var for task in tasks), ",")
   code = "write(lun) $(vars)"
   return code
end

function jwrdata(tasks::Vector{CodegenTask})
   vars   = join((task.var for task in tasks), ", ")
   nbytes = sum(size(task) for task in tasks)
   codes  = [ "$(vars) = shift!(data)",
              "nwritten = write(f, $(vars))",
              "@test nwritten == $(nbytes)" ]
   return codes
end

function jrddata(tasks::Vector{CodegenTask})
   if isempty(tasks)
      return [ "read(f)" ]
   end
   specs = String[]
   tests = String[]
   for task in tasks
      spec = "$(task.jtype)"
      typ  = "$(task.jtype)"
      if task.sz != (1,)
         dims = join( ("$dim" for dim in task.sz), "," )
         specsyntax = rand([:array, :short, :shorter])
         if specsyntax == :array
            spec = "Array{$(typ)}($(dims))"
         elseif specsyntax == :short
            spec = "($spec, ($(dims)))"
         elseif specsyntax == :shorter
            spec = "($spec, $(dims))"
         else
            error("can't happen")
         end
         typ = "Array{$(typ),$(length(task.sz))}"
      end
      push!(specs, spec)
      push!(tests, "@test typeof($(task.var)) == $(typ)")
      push!(tests, "@test sizeof($(task.var)) == $(size(task))")
   end
   vars = join((task.var for task in tasks), ", ")
   vartup = (length(tasks)==1) ? vars : "($(vars))"
   specstr = join(specs, ", ")
   codes = [ "$(vars) = read(f, $(specstr))",
             tests...,
             "push!(data, $(vartup))" ]
   return codes
end


function gencode(nscalar=5, narray=3, nstrlen=3; seed=1)
# will generate (8+nstrlen)*(nscalar+3*narray) CodegenTasks
   srand(seed)

   numtypes = [
      ( Int8 ,      "integer(kind=int8)"   ),
      ( Int16,      "integer(kind=int16)"  ),
      ( Int32,      "integer(kind=int32)"  ),
      ( Int64,      "integer(kind=int64)"  ),
      ( Float32,    "real(kind=real32)"    ),
      ( Float64,    "real(kind=real64)"    ),
      ( Complex64,  "complex(kind=real32)" ),
      ( Complex128, "complex(kind=real64)" ) ]
   strtypes = [
      ( FString{n}, "character(len=$n)" ) for n in rand(1:200,nstrlen) ]
   types = vcat(numtypes, strtypes)

   dims0 = [ ( 1, ) for i=1:nscalar ]
   dims1 = [ ( rand(1:10_000), ) for i=1:narray ]
   dims2 = [ ( rand(1:100), rand(1:100) ) for i=1:narray ]
   dims3 = [ ( rand(1:10), rand(1:10), rand(1:10) ) for i=1:narray ]
   dims  = vcat(dims0, dims1, dims2, dims3)

   fdeclf = open("fdecl.f90", "w")
   fwrf = open("fwrite.f90", "w")
   jwrf = open("jwrite.jl", "w")
   jrdf = open("jread.jl", "w")
   jskf = open("jskip.jl", "w")
   print(jwrf, "function writedata(f::FortranFile, data)\n")
   print(jrdf, "function readdata(f::FortranFile)\n   data = Any[]\n")
   print(jskf, "function skipdata(f::FortranFile)\n   data = Any[]\n")

   tasks = CodegenTask[]
   itask = 1
   for (jt,ft) in types, sz in dims
      var = "var$(itask)"
      push!( tasks, CodegenTask(jt, ft, sz, var) )
      itask += 1
   end

   for task in tasks
      println(fdeclf, "   ", fdecl(task))
      for code in fmkdata(task)
         println(fwrf, "   ", code)
      end
   end
   
   shuffle!(tasks)
   taskgroups = Vector{CodegenTask}[]
   itask = 1
   while itask <= length(tasks)
      jtask = min(itask + rand(0:3), length(tasks))
      push!( taskgroups, tasks[itask:jtask] )
      itask = jtask + 1
   end

   for tg in taskgroups
      println(fwrf, "   ", fwrdata(tg))
      for line in jwrdata(tg); println(jwrf, "   ", line); end
      for line in jrddata(tg); println(jrdf, "   ", line); end
      for line in jrddata(tg[1:rand(0:end-1)]); println(jskf, "   ", line); end
   end

   print(jwrf, "end\n")
   print(jrdf, "   return data\nend\n")
   print(jskf, "   return data\nend\n")
   close(fwrf)
   close(jwrf)
   close(jrdf)
   close(jskf)
end


gencode(1,1,1,seed=12345678)

