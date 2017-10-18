import Base: sizeof, print, show, convert, read, write, bswap, ==


const Fchar = Cchar

"""
    FString{L}

Datatype for reading and writing character strings from `FortranFile`s.
The type parameter `L` signifies the length of the string.
This is the equivalent of the Fortran datatype `CHARACTER(len=L)`.
"""
struct FString{L}
   data :: Array{Fchar,1}
end

sizeof(::Type{FString{N}}) where {N} = N
sizeof(::FString{N}) where {N} = N
sizeof(a::Array{FString{N}}) where {N} = N*length(a)

print(io::IO, ::Type{FString{N}}) where {N} = print(io, "FString{$N}")
show(io::IO, T::Type{FString{N}}) where {N} = print(io, T)
print(io::IO, s::FString{N}) where {N} = print(io, trimstring(s))
show(io::IO, s::FString{N}) where {N} = begin print(io, "FString($N,"); show(io, trimstring(s)); print(io, ")") end

==(a::FString, b::FString) = trimstring(a)==trimstring(b)

bswap(s::FString{N}) where {N} = s # no conversion needed for byte-based strings

function convert(::Type{FString{N}}, s::String) where {N}
   l = length(s)
   FString{N}( [ Fchar((i>l) ? ' ' : s[i]) for i=1:N ] )
end

"""
    FString(N, s::String)

Convert the Julia `String` `s` to an `FString{N}`.
`s` must contain only ASCII characters.
As in Fortran, the string will be padded with spaces or truncated in order to reach the desired length.
"""
FString(N, s::String) = convert( FString{N}, s )

convert(::Type{String}, s::FString{N}) where {N} = String(map(Char,s.data))


function read( io::IO, t::Type{FString{N}} ) where {N}
   s = read!(io, Array{Fchar}(N))
   FString{N}(s)
end


function write( io::IO, s::FString{N} ) where {N}
   write(io, s.data)
end

"""
    trimstring(s::FString)

Convert the `FString` `s` into a Julia `String`, where
trailing spaces are removed. Use `String(s)` to keep the spaces.
"""
function trimstring( s::FString{N} ) where {N}
   l = N
   while l>0
      if s.data[l] != Fchar(' '); break; end
      l -= 1
   end
   String( map(Char, s.data[1:l]) )
end

