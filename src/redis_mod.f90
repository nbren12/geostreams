module redis_mod

  interface 
    subroutine iarray_to_redis(f, dims, ndims) bind ( c )
      use iso_c_binding
      integer(c_int) f(*), dims(*), ndims
    end subroutine
  end interface

  contains

  subroutine array_to_redis(f)
    use iso_c_binding
    integer(c_int) f(:,:)
    integer(c_int) dims(2), ndims
    integer i 

    ndims = 2
    do i=1,ndims
      dims(i) = size(f,i)
    end do

    call iarray_to_redis(f, dims, ndims)

  end


end module redis_mod
