const typeinfo = [
      ( "i1",  "integer(kind=1)" , "1" ),
      ( "i2",  "integer(kind=2)" , "1" ),
      ( "i4",  "integer(kind=4)" , "1" ),
      ( "i8",  "integer(kind=8)" , "1" ),
      ( "r4",  "real(kind=sp)"   , "1.0" ),
      ( "r8",  "real(kind=dp)"   , "1.d0" ),
      ( "c8",  "complex(kind=sp)", "(1.0,0.0)" ),
      ( "c16", "complex(kind=dp)", "(1.d0,0.d0)" ),
      ( "str", "character(len=*)", "'1'" ) ]

function genrandom()
   for (name, ftype, code) in typeinfo
      cmd = `./ftl-expand name=$name type=$ftype code=$code`
      run(pipeline(cmd, stdin="random.ftl", stdout="random$(name).f90"))
   end
end

genrandom()
