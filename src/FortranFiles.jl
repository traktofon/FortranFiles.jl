module FortranFiles

using Compat

export FortranFile
export REC32, REC64, RECVL
export FString, trimstring

include("recordtype.jl")
include("file.jl")
include("recordsimple.jl")
include("recordvl.jl")
include("string.jl")
include("read.jl")
include("write.jl")

end
