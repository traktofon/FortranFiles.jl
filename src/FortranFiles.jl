module FortranFiles

using Compat

export FortranFile, rewind
export RECMRK4B, RECMRK8B
export FString, trimstring

include("types.jl")
include("file.jl")
include("withoutsubrecords.jl")
include("withsubrecords.jl")
include("string.jl")
include("read.jl")
include("write.jl")

end
