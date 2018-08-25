
"""
    FortranIOError(msg)

Exception thrown if an IO operation on a FortranFile fails or cannot be performed.
Argument `msg` is a description of the failure mode.
"""
struct FortranIOError <: Exception
   msg::String
end

throwftnio(msg) = throw(FortranIOError(msg))

Base.showerror(io::IO, ex::FortranIOError) = print(io, "FortranIOError: $(ex.msg)")

