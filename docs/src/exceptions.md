# Exceptions

The following exception type is used to signal errors when handling `FortranFile`s.

```@docs
FortranFilesError
```

The errors could be:

* using unsupported features, or invalid combinations of features
* I/O errors related to the Fortran layer, e.g. non-matching record markers.
  I/O errors on the underlying `IO`, e.g. read/write failure, will show up
  as one of the Julia built-in exceptions.

