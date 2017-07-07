program gendatadirect

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
   integer           :: lun, argc, reclen, rl
   integer,parameter :: n = 73
   integer,parameter :: sl = 11

   integer(kind=int8)   :: vari1(n)
   integer(kind=int16)  :: vari2(n)
   integer(kind=int32)  :: vari4(n)
   integer(kind=int64)  :: vari8(n)
   real(kind=real32)    :: varr4(n)
   real(kind=real64)    :: varr8(n)
   complex(kind=real32) :: varc8(n)
   complex(kind=real64) :: varc16(n)
   character(len=sl)    :: varstr(n)
   
   argc = command_argument_count()
   if (argc < 1) then
      filename = "data.bin"
   else
      call get_command_argument(1, filename)
   endif

   call random(vari1)
   call random(vari2)
   call random(vari4)
   call random(vari8)
   call random(varr4)
   call random(varr8)
   call random(varc8)
   call random(varc16)
   call random(varstr)

   reclen = 0
   inquire(iolength=rl) vari1
   reclen = max(reclen,rl)
   inquire(iolength=rl) vari2
   reclen = max(reclen,rl)
   inquire(iolength=rl) vari4
   reclen = max(reclen,rl)
   inquire(iolength=rl) vari8
   reclen = max(reclen,rl)
   inquire(iolength=rl) varr4
   reclen = max(reclen,rl)
   inquire(iolength=rl) varr8
   reclen = max(reclen,rl)
   inquire(iolength=rl) varc8
   reclen = max(reclen,rl)
   inquire(iolength=rl) varc16
   reclen = max(reclen,rl)
   inquire(iolength=rl) varstr
   reclen = max(reclen,rl)
   
   open(newunit=lun, file=filename, form="unformatted", action="write", status="replace", access="direct", recl=reclen)
   write(lun, rec=1)  vari1
   write(lun, rec=2)  vari2
   write(lun, rec=3)  vari4
   write(lun, rec=4)  vari8
   write(lun, rec=11) varr4
   write(lun, rec=12) varr8
   write(lun, rec=21) varc8
   write(lun, rec=22) varc16
   write(lun, rec=30) varstr
   write(lun, rec=16) varc16 ! going back
   write(lun, rec=16) varstr ! overwriting
   close(lun)

end program gendatadirect
