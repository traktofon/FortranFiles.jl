module randutil

   use,intrinsic :: iso_fortran_env

   implicit none
   private

   public :: i1rand, i2rand, i4rand, i8rand, &
             r4rand, r8rand, c8rand, c16rand, strrand

contains

   subroutine i1rand(x)
      integer(kind=1), intent(out) :: x
      real(kind=REAL32) :: r
      call random_number(r)
      x = floor(256*r) - 128
   end subroutine i1rand
   
   subroutine i2rand(x)
      integer(kind=2), intent(out) :: x
      real(kind=REAL32) :: r
      call random_number(r)
      x = floor(65536*r) - 32768
   end subroutine i2rand
   
   subroutine i4rand(x)
      integer(kind=4), intent(out) :: x
      integer(kind=2) :: r(2)
      call i2rand(r(1))
      call i2rand(r(2))
      x = transfer(r,x)
   end subroutine i4rand
   
   subroutine i8rand(x)
      integer(kind=8), intent(out) :: x
      integer(kind=4) :: r(2)
      call i4rand(r(1))
      call i4rand(r(2))
      x = transfer(r,x)
   end subroutine i8rand
   
   subroutine r4rand(x)
      real(kind=REAL32), intent(out) :: x
      call random_number(x)
   end subroutine r4rand

   subroutine r8rand(x)
      real(kind=REAL64), intent(out) :: x
      call random_number(x)
   end subroutine r8rand

   subroutine c8rand(x)
      complex(kind=REAL32), intent(out) :: x
      real(kind=REAL32) :: r(2)
      call random_number(r)
      x = cmplx(r(1), r(2), kind=REAL32)
   end subroutine c8rand

   subroutine c16rand(x)
      complex(kind=REAL64), intent(out) :: x
      real(kind=REAL64) :: r(2)
      call random_number(r)
         x = cmplx(r(1), r(2), kind=REAL64)
      end subroutine c16rand

      subroutine chrrand(x)
         character, intent(out) :: x
      real(kind=REAL32) :: r
      call random_number(r)
      x = char(floor(32 + 96*r))
   end subroutine chrrand

   subroutine strrand(x)
      character(len=*), intent(out) :: x
      integer :: i
      do i = 1,len(x)
         call chrrand(x(i:i))
      end do
   end subroutine strrand

end module randutil

