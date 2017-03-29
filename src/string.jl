import Base: sizeof, read, write


const Fchar = Cchar

immutable FString{N}
   data :: Array{Fchar,1}
end

sizeof{N}(::FString{N}) = N
sizeof{N}(a::Array{FString{N}}) = N*length(a)


function Base.convert{N}(::Type{FString{N}}, s::String)
   l = length(s)
   FString{N}( [ Fchar(i>l?' ':s[i]) for i=1:N ] )
end

FString(N, s::String) = convert( FString{N}, s )

Base.convert{N}(::Type{String}, s::FString{N}) = String(map(Char,s.data))


function read{N}( io::IO, t::Type{FString{N}} )
   s = read(io, Fchar, N)
   FString{N}(s)
end


function write{N}( io::IO, s::FString{N} )
   write(io, s.data)
end


function trimstring{N}( s::FString{N} )
   l = N
   while l>0
      if s.data[l] != Fchar(' '); break; end
      l -= 1
   end
   String( map(Char, s.data[1:l]) )
end
