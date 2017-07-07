# Writing Data

```@docs
write
```

## Examples

The following examples show how to write Julia code that corresponds to
certain Fortran `WRITE` statements. The Julia code assumes that `f` refers
to an opened `FortranFile` in sequential access mode, while the Fortran
code assumes that `lun` refers to a logical unit number for a connected file.

For direct access mode, each `write` call additionally needs to specify the
number of the record to write, by using the `rec` keyword argument.
E.g. to write the first record, use `write(f, rec=1, ...)`.

#### Writing scalars

```julia
i = Int32(1)
write(f, i)
```
corresponds to
```fortran
integer(kind=int32)::i
i = 1
write(lun) i
```

See [Datatypes](@ref) for the Julia equivalents of the Fortran datatypes.

#### Writing arrays

```julia
A = zeros(Float32, 10, 20)
write(f, A)
```
corresponds to
```fortran
real(kind=real32),dimension(10,20)::A
A = 0.0
write(lun) A                          ! modern Fortran
write(lun) ((A(i,j), i=1,10), j=1,20) ! Fortran77
```

#### Writing strings

```julia
s = FString(20, "blabla")
write(f, s)
```
corresponds to
```fortran
character(len=20)::s
s = "blabla"
write(lun) s
```

#### Writing a record with multiple data

Combining the above into a single record,
```julia
i = Int32(1)
A = zeros(Float32, 10, 20)
s = FString(20, "blabla")
write(f, i, A, s)
```
corresponds to
```fortran
integer(kind=int32)::i
real(kind=real32),dimension(10,20)::A
character(len=20)::s
i = 1
A = 0.0
s = "blabla"
write(lun) i,A,s
```
