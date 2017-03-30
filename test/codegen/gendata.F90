program gendata

   use,intrinsic :: iso_fortran_env

   use :: randutili1
   use :: randutili2
   use :: randutili4
   use :: randutili8
   use :: randutilr4
   use :: randutilr8
   use :: randutilc8
   use :: randutilc16
   use :: randutilstr

   implicit none

   integer,parameter :: sp = REAL32
   integer,parameter :: dp = REAL64

   integer :: lun
#include "fdecl.f90"

   open(newunit=lun, file="test.bin", form="unformatted", status="unknown")
#include "fwrite.f90"
   close(lun)

end program gendata
