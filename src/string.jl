import Base: sizeof, print, show, convert, read, write, bswap, ==


const Fchar = Cchar

"""
    FString{N}

Datatype for reading and writing character strings from `FortranFile`s.
The type parameter `N` signifies the length of the string.
This is the equivalent of the Fortran datatype `CHARACTER(len=N)`.
"""
immutable FString{N}
   data :: Array{Fchar,1}
end

sizeof{N}(::Type{FString{N}}) = N
sizeof{N}(::FString{N}) = N
sizeof{N}(a::Array{FString{N}}) = N*length(a)

print{N}(io::IO, ::Type{FString{N}}) = print(io, "FString{$N}")
show{N}(io::IO, T::Type{FString{N}}) = print(io, T)
print{N}(io::IO, s::FString{N}) = print(io, trimstring(s))
show{N}(io::IO, s::FString{N}) = begin print(io, "FString($N,"); show(io, trimstring(s)); print(io, ")") end

==(a::FString, b::FString) = trimstring(a)==trimstring(b)

bswap{N}(s::FString{N}) = s # no conversion needed for byte-based strings

function convert{N}(::Type{FString{N}}, s::String)
   l = length(s)
   FString{N}( [ Fchar(i>l?' ':s[i]) for i=1:N ] )
end

"""
    FString(N, s::String)

Convert the Julia `String` `s` to an `FString{N}`.
`s` must contain only ASCII characters.
As in Fortran, the string will be padded with spaces or truncated in order to reach the desired length.
"""
FString(N, s::String) = convert( FString{N}, s )

convert{N}(::Type{String}, s::FString{N}) = String(map(Char,s.data))


function read{N}( io::IO, t::Type{FString{N}} )
   s = read(io, Fchar, N)
   FString{N}(s)
end


function write{N}( io::IO, s::FString{N} )
   write(io, s.data)
end

"""
    trimstring(s::FString)

Convert the `FString` `s` into a Julia `String`, where
trailing spaces are removed. Use `String(s)` to keep the spaces.
"""
function trimstring{N}( s::FString{N} )
   l = N
   while l>0
      if s.data[l] != Fchar(' '); break; end
      l -= 1
   end
   String( map(Char, s.data[1:l]) )
end

