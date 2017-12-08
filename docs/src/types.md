# Datatypes

When reading files created by a Fortran program, you need to be aware
of the exact datatypes that were used to write the data. It is essential
to specify the correct corresponding Julia datatype when using the
`read` function provided by this package. Especially, note that the
default Fortran `INTEGER` datatype on most systems corresponds to
Julia's `Int32` datatype, which differs from Julia's default `Int`
datatype on 64-bit systems.

Likewise, when using this package to write Julia data into files which
should be readable by a Fortran program, you need to define your data
with the correct datatypes, or convert them appropriately before using
them in the `write` function.


## Type Correspondence

The following table lists the Julia types which correspond to the standard Fortran types:

| Fortran type         | a.k.a.           | Julia type   |
| -------------------- | ---------------- | ------------ |
| INTEGER(KIND=INT8)   | INTEGER*1        | Int8         |
| INTEGER(KIND=INT16)  | INTEGER*2        | Int16        |
| INTEGER(KIND=INT32)  | INTEGER*4        | Int32        |
| INTEGER(KIND=INT64)  | INTEGER*8        | Int64        |
| REAL(KIND=REAL32)    | REAL*4           | Float32      |
| REAL(KIND=REAL64)    | REAL*8           | Float64      |
| COMPLEX(KIND=REAL32) | COMPLEX*8        | Complex64    |
| COMPLEX(KIND=REAL64) | COMPLEX*16       | Complex128   |
| CHARACTER(LEN=*N*)   | CHARACTER\*(*N*) | FString{*N*} |

The first column lists the datatypes using the kind parameters according to the
Fortran2008 standard. Most Fortran programs will likely use type declarations as
in the second column, although these don't conform to the Fortran standard.
If the Fortran program doesn't specify the kind, then the exact Fortran datatype
also depends on the compiler options (which can influence the default kind of
integers and reals).

This package currently only supports one kind of `CHARACTER` data, namely
ASCII characters with one byte of storage per character.


## Strings

Fortran character strings possess an inherent length property. To support reading
and writing such data, this package defines an `FString` datatype which takes the
length as a type parameter:

```@docs
FString{L}
FString(L, s::String)
```

There is not much you can do with `FString`s, except `print`ing them and
`write`ing them back to a `FortranFile`.  For conversion to a Julia `String`,
use the following:

```@docs
trimstring
```

To make it easier to convert Fortran code into Julia, the following
functions are provided for convenience:

```@docs
trimlen
trim
```


## Logicals

It is currently undecided how best to support I/O of Fortran `LOGICAL` data,
pending some design decisions.

For the moment, such data can be read or written by treating them as integer data,
where 0 corresponds to `false` and 1 or -1 corresponds to `true` (depending on the
Fortran system). According to the Fortran standard, the storage size for the default
`LOGICAL` kind must be the same as for the default `INTEGER` kind, therefore you
probably want to use Int32 data in Julia.

