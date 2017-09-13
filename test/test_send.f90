program name
  implicit none
  integer, parameter ::n=200, m=100
  integer :: dims(2)
  integer f(n,m)
  integer ndims
  integer i, j
  do j=1,m
    do i=1,n
      f(i,j) = i
    end do
  end do

  ndims = 2
  dims = (/n,m/)

  call array_to_redis(f)
contains

  subroutine array_to_redis(f)
    use iso_c_binding
    integer(c_int) f(:,:)
    integer(c_int) dims(2), ndims
    integer i 

    interface 
    subroutine iarray_to_redis(f, dims, ndims) bind ( c )
      use iso_c_binding
      integer(c_int) f(*), dims(*), ndims
    end subroutine
    end interface

    ndims = 2
    do i=1,ndims
      dims(i) = size(f,i)
    end do

    call iarray_to_redis(f, dims, ndims)

  end

      

end program name
