import Base: read


function read( f::FortranFile, spec )
   rec = Record(f)
   data = read_spec(rec, spec)
   close(rec)
   return data
end

function read( f::FortranFile, specs... )
   rec = Record(f)
   data = [ read_spec(rec,spec) for spec in specs ]
   close(rec)
   return tuple(data...)
end


function read_spec{T}( io::Record, spec::Type{T} )
   read(io, spec)::T
end

function read_spec{I<:Integer}( io::Record, spec::Tuple{DataType,I} )
   T,n = spec
   read(io, T, n)::Array{T,1}
end

function read_spec{N}( io::Record, spec::Tuple{DataType, Vararg{Integer,N}} )
   T = spec[1]
   szi = map(Int, spec[2:end])
   read(io, T, szi)::Array{T,N}
end

function read_spec{N}( io::Record, spec::Tuple{DataType, Tuple{Vararg{Integer,N}}} )
   T,sz = spec
   szi = map(Int, sz)
   read(io, T, szi)::Array{T,N}
end

