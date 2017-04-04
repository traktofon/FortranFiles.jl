using Documenter, FortranFiles

makedocs(
   modules  = [FortranFiles],
   format   = :html,
   sitename = "FortranFiles.jl",
   pages = [
      "Home" => "home.md",
      "files.md",
      "types.md",
      "read.md",
      "write.md",
      "index.md"
   ]
)

deploydocs(
   repo   = "github.com/traktofon/FortranFiles.jl.git",
   target = "build",
   branch = "gh-pages",
   julia  = "release",
   deps   = nothing,
   make   = nothing
)
