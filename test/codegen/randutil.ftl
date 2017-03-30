module randutil#name#

   use,intrinsic :: iso_fortran_env

   implicit none
   private

   public :: random

   interface random
      module procedure random0
      module procedure random1
      module procedure random2
      module procedure random3
   end interface random

   integer,parameter :: sp = REAL32
   integer,parameter :: dp = REAL64

contains

   subroutine random0(x)
      #type#, intent(out) :: x
      x = #code#
   end

   subroutine random1(arr)
      #type#, intent(out) :: arr(:)
      integer :: i
      do i = lbound(arr,1),ubound(arr,1)
         call random0(arr(i))
      end do
   end

   subroutine random2(arr)
      #type#, intent(out) :: arr(:,:)
      integer :: i,j
      do j = lbound(arr,2),ubound(arr,2)
         do i = lbound(arr,1),ubound(arr,1)
            call random0(arr(i,j))
         end do
      end do
   end

   subroutine random3(arr)
      #type#, intent(out) :: arr(:,:,:)
      integer :: i,j,k
      do k = lbound(arr,3),ubound(arr,3)
         do j = lbound(arr,2),ubound(arr,2)
            do i = lbound(arr,1),ubound(arr,1)
               call random0(arr(i,j,k))
            end do
         end do
      end do
   end

end module randutil#name#

! vim: set syntax=fortran ts=3 sw=3 expandtab :
