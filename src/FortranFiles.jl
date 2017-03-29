module FortranFiles

using Compat

export FortranFile
export REC32, REC64, RECFL
export FString, trimstring

include("recordtypes.jl")
include("file.jl")
include("recordsimple.jl")
include("recordflexible.jl")
include("string.jl")
include("read.jl")
include("write.jl")

end
