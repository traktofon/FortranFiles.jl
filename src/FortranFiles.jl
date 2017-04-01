module FortranFiles

using Compat

export FortranFile, rewind
export RECMRK32, RECMRK64, RECMRKFL, RECMRKDEF
export FString, trimstring

include("recordtypes.jl")
include("file.jl")
include("recordsimple.jl")
include("recordflexible.jl")
include("string.jl")
include("read.jl")
include("write.jl")

end
