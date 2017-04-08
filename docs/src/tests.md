# Package Tests

This package can be tested in the usual Julia way:
```julia
Pkg.test("FortranFiles")
```
However, in order to test whether files written by a Fortran program
are properly read, this first needs to generate some Fortran output.
Therefore the following external dependencies are required to run the
tests:
* gfortran (a reasonably recent version, which understands the `-std=f2008` flag)
* GNU make
* Perl
Additionally, the test suite needs the following Julia packages, which can
be installed with `Pkg.add`:
* Iterators

The tests perform the following steps:
1. Create the Fortran source code, and compile it.
1. Create the Julia source code for reading the Fortran data,
   and for writing it out again.
1. Run the Fortran program. This produces the input test data.
1. Use the Julia code to read in the test data. Datatype and storage
   size of the read items are checked against their expected values.
1. Use the Julia code to read parts of the test data, i.e. records are
   skipped or read incompletely.
1. Use the Julia code to write the data to an output file.
1. Check that the input and output file are identical.
This sequence of steps is performed for each of the tested record marker types,
and each of the supported byte orders,
using the appropriate gfortran compiler options to adjust the Fortran output.

