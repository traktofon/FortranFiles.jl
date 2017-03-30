program gendata

   use,intrinsic :: iso_fortran_env

   use :: randomi1
   use :: randomi2
   use :: randomi4
   use :: randomi8
   use :: randomr4
   use :: randomr8
   use :: randomc8
   use :: randomc16
   use :: randomstr

   implicit none

   integer,parameter :: sp = REAL32
   integer,parameter :: dp = REAL64

   integer :: lun
#include "fdecl.f90"

   open(newunit=lun, file="data.bin", form="unformatted", status="unknown")
#include "fwrite.f90"
   close(lun)

end program gendata
