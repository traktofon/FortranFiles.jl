# FortranFiles.jl

A Julia package for reading and writing Fortran unformatted (i.e. binary) files.


## Features ##

Currently the following features are implemented and working:

* Sequential Access mode
  * 4-byte record markers, with subrecord support (allowing records larger than 2 GiB)
  * 8-byte record markers (used by early versions of gfortran)
* Direct Access mode 
  * fixed-size records without any record markers
* Most standard Fortran datatypes, including arrays and strings
* "Inhomogeneous" records, i.e. records made from multiple different datatypes
* Byte-order conversion (little endian ⟷ big endian) 

The following features are not (yet) supported:

* Derived Type I/O
* Equivalents of BACKSPACE and ENDFILE


## Documentation

```@contents
Pages = [
   "files.md",
   "types.md",
   "read.md",
   "write.md",
   "exceptions.md",
   "tests.md",
   "theindex.md"
]
```


## Acknowledgments

The `FortranFiles.jl` logo has been produced with help of the
[Virtual Keypunch service](http://www.masswerk.at/keypunch/)
from [masswerk.at](http://www.masswerk.at/).
The punchcard artwork is Copyright 2012 Norbert Landsteiner, mass:werk – media environments.
It is here used by kind permission.

