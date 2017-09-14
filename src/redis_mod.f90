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

  subroutine stream_data(f)
    use iso_c_binding
    integer(c_int) :: f(:,:)
    integer(c_int) :: n, m
    external publish_to_redis
    ! TODO this is a function stub
    n = size(f, 1)
    m = size(f, 2)

    call publish_to_redis(f, n, m)

  end subroutine stream_data


end module redis_mod
