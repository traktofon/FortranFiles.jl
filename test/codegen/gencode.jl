import FortranFiles: FString
import Base: size

immutable CodegenTask
   jtype :: DataType
   ftype :: String
   sz    :: Dims
   var   :: String
end

# size(task::CodegenTask) = sizeof(task.jtype) * prod(task.sz)

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
   vars = join((task.var for task in tasks), ", ")
   code = "write(outfile, $(vars))"
   return code
end

function jrddata(tasks::Vector{CodegenTask})
   if isempty(tasks); return "read(infile)"; end
   vars = join((task.var for task in tasks), ", ")
   specs = String[]
   for task in tasks
      spec = "$(task.jtype)"
      if task.sz != (1,)
         dims = join( ("$dim" for dim in task.sz), "," )
         if rand(Bool)
            spec = "($spec, $(dims))"
         else
            spec = "($spec, ($(dims)))"
         end
      end
      push!(specs, spec)
   end
   specstr = join(specs, ", ")
   code = "$(vars) = read(infile, $(specstr))"
   return code
end


function gencode(seed)
   srand(seed)

   numtypes = [
      ( Int8 ,      "integer(kind=1)"  ),
      ( Int16,      "integer(kind=2)"  ),
      ( Int32,      "integer(kind=4)"  ),
      ( Int64,      "integer(kind=8)"  ),
      ( Float32,    "real(kind=sp)"    ),
      ( Float64,    "real(kind=dp)"    ),
      ( Complex64,  "complex(kind=sp)" ),
      ( Complex128, "complex(kind=dp)" ) ]
   strtypes = [
      ( FString{n}, "character(len=$n)" ) for n in rand(1:200,5) ]
   types = vcat(numtypes, strtypes)

   dims0 = [ ( 1, ) for i=1:10 ]
   dims1 = [ ( rand(1:10_000), ) for i=1:10 ]
   dims2 = [ ( rand(1:100), rand(1:100) ) for i=1:10 ]
   dims3 = [ ( rand(1:10), rand(1:10), rand(1:10) ) for i=1:10 ]
   dims  = vcat(dims0, dims1, dims2, dims3)

   fdeclf = open("fdecl.f90", "w")
   fwrf = open("fwrite.f90", "w")
   jwrf = open("jwrite.jl", "w")
   jrdf = open("jread.jl", "w")
   jskf = open("jskip.jl", "w")

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
      println(jwrf, "   ", jwrdata(tg))
      println(jrdf, "   ", jrddata(tg))
      println(jskf, "   ", jrddata(tg[1:rand(0:end)]))
   end

   close(fwrf)
   close(jwrf)
   close(jrdf)
   close(jskf)

   taskgroups
end


gencode(12345678)

