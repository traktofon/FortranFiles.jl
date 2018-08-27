# Like @test_throws, but for macros.
# Julia-0.7 and later always wrap the exception in a LoadError.

@static if VERSION >= v"0.7.0-alpha.0"
   macro test_macro_throws(typ, expr)
      quote
         @test_throws $typ begin
            try
               $expr
            catch e
               rethrow(e.error)
            end
         end
      end
   end
else
   macro test_macro_throws(typ, expr)
      quote
         @test_throws $typ $expr
      end
   end
end

