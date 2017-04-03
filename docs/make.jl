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
