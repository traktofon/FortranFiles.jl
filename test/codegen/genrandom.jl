const typeinfo = [
      ( "i1",  "integer(kind=1)" , "i1rand" ),
      ( "i2",  "integer(kind=2)" , "i2rand" ),
      ( "i4",  "integer(kind=4)" , "i4rand" ),
      ( "i8",  "integer(kind=8)" , "i8rand" ),
      ( "r4",  "real(kind=sp)"   , "r4rand" ),
      ( "r8",  "real(kind=dp)"   , "r8rand" ),
      ( "c8",  "complex(kind=sp)", "c8rand" ),
      ( "c16", "complex(kind=dp)", "c16rand" ),
      ( "str", "character(len=*)", "strrand" ) ]

function genrandom()
   for (name, ftype, func) in typeinfo
      cmd = `./ftl-expand name=$name type=$ftype func=$func`
      run(pipeline(cmd, stdin="random.ftl", stdout="random$(name).f90"))
   end
end

genrandom()
