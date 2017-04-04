var documenterSearchIndex = {"docs": [

{
    "location": "home.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "home.html#FortranFiles.jl-1",
    "page": "Home",
    "title": "FortranFiles.jl",
    "category": "section",
    "text": "A Julia package for reading and writing Fortran unformatted (i.e. binary) files."
},

{
    "location": "home.html#Features-1",
    "page": "Home",
    "title": "Features",
    "category": "section",
    "text": "Currently the following features are implemented and working:Sequential Access mode\n4-byte record markers, with subrecord support (allowing records larger than 2 GiB)\n8-byte record markers (used by early versions of gfortran)\nMost standard Fortran datatypes, including arrays and strings\n\"Inhomogeneous\" records, i.e. records made from multiple different datatypesThe following features are not (yet) supported:Direct Access mode\nDerived Type I/O\nEquivalents of BACKSPACE and ENDFILE"
},

{
    "location": "home.html#Documentation-1",
    "page": "Home",
    "title": "Documentation",
    "category": "section",
    "text": "Pages = [\n   \"files.md\",\n   \"types.md\",\n   \"read.md\",\n   \"write.md\",\n   \"index.md\"\n]"
},

{
    "location": "files.html#",
    "page": "Files",
    "title": "Files",
    "category": "page",
    "text": ""
},

{
    "location": "files.html#Files-1",
    "page": "Files",
    "title": "Files",
    "category": "section",
    "text": ""
},

{
    "location": "files.html#Terminology-1",
    "page": "Files",
    "title": "Terminology",
    "category": "section",
    "text": "When opening a file in Fortran, you can specify its access mode. The default and most commonly used mode is sequential access, and this is the only mode currently supported by this package. (If the Fortran program uses stream access mode, then the file contains plain binary data, which can be easily read with Julia's built-in facilities.)In Fortran, files are organized into records. Each READ or WRITE statement in Fortran processes a complete record. This Julia package emulates this behavior, i.e. each call to read or write will process a whole record.In sequential access mode, records can only be accessed sequentially, but they can be of variable length. The length of a record is determined by the amount of data passed to the WRITE statement. The length of the record is also written to the file, encoded in record markers which preceed and follow the record. Unfortunately, Fortran compilers have used various ways to encode the record markers (the following is from personal recollection and may be incorrect):G77 used 4 bytes, so that records could be no longer than 2 GiB.\nIfort uses 4 bytes, and uses the sign bit to signal that more data will follow. That is, the record is split into subrecords, where each subrecord has its own record markers. For records smaller than 2 GiB, this is compatible to G77.\nGfortran 4.0 and 4.1 offered 8-byte record markers as an alternative to G77-style record markers, and used them by default (at least on 64-bit systems).\nGfortran 4.2 introduced Ifort-compatible record markers. These are now the default.All these kinds of record markers are supported by this package."
},

{
    "location": "files.html#FortranFiles.FortranFile",
    "page": "Files",
    "title": "FortranFiles.FortranFile",
    "category": "Type",
    "text": "FortranFile(io::IO; kwargs...)\n\nWrap the given IO stream as a FortranFile containing Fortran \"unformatted\" (i.e. binary) data. The keyword arguments can be:\n\naccess for specifying the access mode; a String being one of\n\"sequential\": sequential access as in Fortran, where records have leading and trailing record markers. This is the default.\n[nothing else at the moment]\nmarker: for specifying the type of record marker; one of\nRECMRK4B: 4-byte record markers (with support for subrecords) [default]\nRECMRK8B: 8-byte record markers\n\nThe returned FortranFile can be used with Julia's read and write functions. See their documentation for more information.\n\n\n\nFortranFile(fn::String [, mode=\"r\" ]; kwargs...)\n\nOpen a file containing Fortran unformatted (i.e. binary) data for reading or writing, depending on mode which is used as in open. The keyword arguments are as in FortranFile(io::IO; kwargs...).\n\n\n\n"
},

{
    "location": "files.html#Opening-files-1",
    "page": "Files",
    "title": "Opening files",
    "category": "section",
    "text": "To open a file which contains Fortran unformatted data, use one of the following methods:FortranFileSee Reading Data and Writing Data for how to read or write data to FortranFiles."
},

{
    "location": "files.html#FortranFiles.rewind",
    "page": "Files",
    "title": "FortranFiles.rewind",
    "category": "Function",
    "text": "Re-position a FortranFile at its beginning.\n\n\n\n"
},

{
    "location": "files.html#Other-functions-on-FortranFiles-1",
    "page": "Files",
    "title": "Other functions on FortranFiles",
    "category": "section",
    "text": "To close the file, use the standard Julia close function.The following functions are provided to emulate certain Fortran I/O statements:rewind"
},

{
    "location": "files.html#Examples-1",
    "page": "Files",
    "title": "Examples",
    "category": "section",
    "text": "The following examples show how to write Julia code that corresponds to certain Fortran OPEN statements."
},

{
    "location": "files.html#Opening-a-file-read-only-1",
    "page": "Files",
    "title": "Opening a file read-only",
    "category": "section",
    "text": "f = FortranFile(\"data.bin\")corresponds tointeger::lun\nopen(newunit=lun, file=\"data.bin\", form=\"unformatted\", action=\"read\", status=\"old\")"
},

{
    "location": "files.html#Opening-a-file-for-writing-1",
    "page": "Files",
    "title": "Opening a file for writing",
    "category": "section",
    "text": "f = FortranFile(\"data.bin\", \"w\")corresponds tointeger::lun\nopen(newunit=lun, file=\"data.bin\", form=\"unformatted\", action=\"write\", status=\"replace\")"
},

{
    "location": "files.html#Opening-a-file-for-reading-and-writing-in-append-mode-1",
    "page": "Files",
    "title": "Opening a file for reading and writing in append mode",
    "category": "section",
    "text": "f = FortranFile(\"data.bin\", \"a+\")probably corresponds tointeger::lun\nopen(newunit=lun, file=\"data.bin\", form=\"unformatted\", action=\"readwrite\", position=\"append\", status=\"unknown\")"
},

{
    "location": "types.html#",
    "page": "Datatypes",
    "title": "Datatypes",
    "category": "page",
    "text": ""
},

{
    "location": "types.html#Datatypes-1",
    "page": "Datatypes",
    "title": "Datatypes",
    "category": "section",
    "text": "When reading files created by a Fortran program, you need to be aware of the exact datatypes that were used to write the data. It is essential to specify the correct corresponding Julia datatype when using the read function provided by this package. Especially, note that the default Fortran INTEGER datatype on most systems corresponds to Julia's Int32 datatype, which differs from Julia's default Int datatype on 64-bit systems.Likewise, when using this package to write Julia data into files which should be readable by a Fortran program, you need to define your data with the correct datatypes, or convert them appropriately before using them in the write function."
},

{
    "location": "types.html#Type-Correspondence-1",
    "page": "Datatypes",
    "title": "Type Correspondence",
    "category": "section",
    "text": "The following table lists the Julia types which correspond to the standard Fortran types:Fortran type a.k.a. Julia type\nINTEGER(KIND=INT8) INTEGER*1 Int8\nINTEGER(KIND=INT16) INTEGER*2 Int16\nINTEGER(KIND=INT32) INTEGER*4 Int32\nINTEGER(KIND=INT64) INTEGER*8 Int64\nREAL(KIND=REAL32) REAL*4 Float32\nREAL(KIND=REAL64) REAL*8 Float64\nCOMPLEX(KIND=REAL32) COMPLEX*8 Complex64\nCOMPLEX(KIND=REAL64) COMPLEX*16 Complex128\nCHARACTER(LEN=N) CHARACTER*(N) FString{N}The first column lists the datatypes using the kind parameters according to the Fortran2008 standard. Most Fortran programs will likely use type declarations as in the second column, although these don't conform to the Fortran standard. If the Fortran program doesn't specify the kind, then the exact Fortran datatype also depends on the compiler options (which can influence the default kind of integers and reals).This package currently only supports one kind of CHARACTER data, namely ASCII characters with one byte of storage per character."
},

{
    "location": "types.html#FortranFiles.FString",
    "page": "Datatypes",
    "title": "FortranFiles.FString",
    "category": "Type",
    "text": "FString{N}\n\nDatatype for reading and writing character strings from FortranFiles. The type parameter N signifies the length of the string. This is the equivalent of the Fortran datatype CHARACTER(len=N).\n\n\n\n"
},

{
    "location": "types.html#FortranFiles.FString-Tuple{Any,String}",
    "page": "Datatypes",
    "title": "FortranFiles.FString",
    "category": "Method",
    "text": "FString(N, s::String)\n\nConvert the Julia String s to an FString{N}. s must contain only ASCII characters. As in Fortran, the string will be padded with spaces or truncated in order to reach the desired length.\n\n\n\n"
},

{
    "location": "types.html#FortranFiles.trimstring",
    "page": "Datatypes",
    "title": "FortranFiles.trimstring",
    "category": "Function",
    "text": "trimstring(s::FString)\n\nConvert the FString s into a Julia String, where trailing spaces are removed. Use String(s) to keep the spaces.\n\n\n\n"
},

{
    "location": "types.html#Strings-1",
    "page": "Datatypes",
    "title": "Strings",
    "category": "section",
    "text": "Fortran character strings possess an inherent length property. To support reading and writing such data, this package defines an FString datatype which takes the length as a type parameter:FString{N}\nFString(N, s::String)There is not much you can do with FStrings, except printing them and writeing them back to a FortranFile.  For conversion to a Julia String, use the following:trimstring"
},

{
    "location": "types.html#Logicals-1",
    "page": "Datatypes",
    "title": "Logicals",
    "category": "section",
    "text": "It is currently undecided how best to support I/O of Fortran LOGICAL data, pending some design decisions.For the moment, such data can be read or written by treating them as integer data, where 0 corresponds to false and 1 or -1 corresponds to true (depending on the Fortran system). According to the Fortran standard, the storage size for the default LOGICAL kind must be the same as for the default INTEGER kind, therefore you probably want to use Int32 data in Julia."
},

{
    "location": "read.html#",
    "page": "Reading Data",
    "title": "Reading Data",
    "category": "page",
    "text": ""
},

{
    "location": "read.html#Base.read",
    "page": "Reading Data",
    "title": "Base.read",
    "category": "Function",
    "text": "read(f::FortranFile [, spec [, spec [, ...]]])\n\nRead data from a FortranFile. Like the READ statement in Fortran, this reads a completely record, regardless of how man specs are given. Each spec can be:\n\na DataType for scalar values; e.g. Int32, Float64, FString{10}\na tuple of DataType and one or more integers, for reading arrays of the given size; e.g. (Int32,4,2) reads an Array{Int32}(4,2)\na tuple of DataType and a tuple of integers, as an alternative way of reading arrays; e.g. (Int32,(4,2)) does the same as the previous one\nan array, for reading into pre-allocated arrays; DataType and size of the array are implied through its Julia type.\n\nReturn value:\n\nif no spec is given: nothing (the record is skipped over)\nif one spec is given: the scalar or array requested\nif more specs are given: a tuple of the scalars and arrays requested, in order\n\n\n\n"
},

{
    "location": "read.html#Reading-Data-1",
    "page": "Reading Data",
    "title": "Reading Data",
    "category": "section",
    "text": "read"
},

{
    "location": "read.html#Examples-1",
    "page": "Reading Data",
    "title": "Examples",
    "category": "section",
    "text": "The following examples show how to write Julia code that corresponds to certain Fortran READ statements. The Julia code assumes that f refers to an opened FortranFile, while the Fortran code assumes that lun refers to a logical unit number for a connected file."
},

{
    "location": "read.html#Reading-a-single-scalar-1",
    "page": "Reading Data",
    "title": "Reading a single scalar",
    "category": "section",
    "text": "x = read(f, Float64)corresponds toreal(kind=real64)::x\nread(lun) x"
},

{
    "location": "read.html#Reading-a-1D-array-1",
    "page": "Reading Data",
    "title": "Reading a 1D array",
    "category": "section",
    "text": "vector = read(f, (Float64,10))       # read into a new array\nvector = zeros(10); read(f, vector)  # read into pre-existing arraycorresponds to (Modern Fortran style)real(kind=real64),dimension(10)::vector\nread(lun) vectorand to (Fortran77 style)integer::i\nreal(kind=real64),dimension(10)::vector\nread(lun) (vector(i), i=1,10)"
},

{
    "location": "read.html#Reading-a-2D-array-1",
    "page": "Reading Data",
    "title": "Reading a 2D array",
    "category": "section",
    "text": "matrix = read(f, (Float64,10,10))      # read into a new array\nmatrix = read(f, (Float64,(10,10)))    # alternative syntax\nmatrix = zeros(10,10); read(f, matrix) # read into existing array\ncorresponds toreal(kind=real64),dimension(10,10)::matrix\nread(lun) matrix"
},

{
    "location": "read.html#Reading-a-character-string-1",
    "page": "Reading Data",
    "title": "Reading a character string",
    "category": "section",
    "text": "fstr = read(f, FString{20})corresponds tocharacter(len=20)::fstr\nread(lun) fstr"
},

{
    "location": "read.html#Reading-a-record-with-multiple-data-1",
    "page": "Reading Data",
    "title": "Reading a record with multiple data",
    "category": "section",
    "text": "i, strings, zmatrix = read(f, Int32, (Fstring{20},10), (Complex128,10,10))corresponds tointeger(kind=int32)::i\ncharacter(len=20),dimension(10)::strings\ncomplex(kind=real64),dimension(10,10)::zmatrix\nread(lun) i,strings,matrix"
},

{
    "location": "read.html#Skipping-over-a-record-1",
    "page": "Reading Data",
    "title": "Skipping over a record",
    "category": "section",
    "text": "read(f)corresponds toread(lun)"
},

{
    "location": "write.html#",
    "page": "Writing Data",
    "title": "Writing Data",
    "category": "page",
    "text": ""
},

{
    "location": "write.html#Base.write",
    "page": "Writing Data",
    "title": "Base.write",
    "category": "Function",
    "text": "write(f::FortranFile, items...)\n\nWrite a data record to a FortranFile. Each item should be a scalar of a Fortran-compatible datatype (e.g. Int32, Float64, FString{10}), or an array of such scalars. If no items are given, an empty record is written. Returns the number of bytes written, not including the space taken up by the record markers.\n\n\n\n"
},

{
    "location": "write.html#Writing-Data-1",
    "page": "Writing Data",
    "title": "Writing Data",
    "category": "section",
    "text": "write"
},

{
    "location": "write.html#Examples-1",
    "page": "Writing Data",
    "title": "Examples",
    "category": "section",
    "text": "The following examples show how to write Julia code that corresponds to certain Fortran WRITE statements. The Julia code assumes that f refers to an opened FortranFile, while the Fortran code assumes that lun refers to a logical unit number for a connected file."
},

{
    "location": "write.html#Writing-scalars-1",
    "page": "Writing Data",
    "title": "Writing scalars",
    "category": "section",
    "text": "i = Int32(1)\nwrite(f, i)corresponds tointeger(kind=int32)::i\ni = 1\nwrite(lun) iSee Datatypes for the Julia equivalents of the Fortran datatypes."
},

{
    "location": "write.html#Writing-arrays-1",
    "page": "Writing Data",
    "title": "Writing arrays",
    "category": "section",
    "text": "A = zeros(Float32, 10, 20)\nwrite(f, A)corresponds toreal(kind=real32),dimension(10,20)::A\nA = 0.0\nwrite(lun) A                          ! modern Fortran\nwrite(lun) ((A(i,j), i=1,10), j=1,20) ! Fortran77"
},

{
    "location": "write.html#Writing-strings-1",
    "page": "Writing Data",
    "title": "Writing strings",
    "category": "section",
    "text": "s = FString(20, \"blabla\")\nwrite(f, s)corresponds tocharacter(len=20)::s\ns = \"blabla\"\nwrite(lun) s"
},

{
    "location": "write.html#Writing-a-record-with-multiple-data-1",
    "page": "Writing Data",
    "title": "Writing a record with multiple data",
    "category": "section",
    "text": "Combining the above into a single record,i = Int32(1)\nA = zeros(Float32, 10, 20)\ns = FString(20, \"blabla\")\nwrite(f, i, A, s)corresponds tointeger(kind=int32)::i\nreal(kind=real32),dimension(10,20)::A\ncharacter(len=20)::s\ni = 1\nA = 0.0\ns = \"blabla\"\nwrite(lun) i,A,s"
},

{
    "location": "index.html#",
    "page": "Index",
    "title": "Index",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Index-1",
    "page": "Index",
    "title": "Index",
    "category": "section",
    "text": "CurrentModule = FortranFilesPages = [\n   \"files.md\",\n   \"types.md\",\n   \"read.md\",\n   \"write.md\"\n]"
},

]}
