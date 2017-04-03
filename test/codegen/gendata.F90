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

   character(len=80) :: filename
   integer           :: lun, argc
#include "fdecl.f90"

   argc = command_argument_count()
   if (argc < 1) then
      filename = "data.bin"
   else
      call get_command_argument(1, filename)
   endif

   open(newunit=lun, file=filename, form="unformatted", action="write", status="replace")
#include "fwrite.f90"
   close(lun)

end program gendata
