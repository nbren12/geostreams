module redis_mod
  use iso_c_binding
  implicit none

  interface
     subroutine redis_test_set(c) bind(c, name='redisTestSet')
       use iso_c_binding
       type(c_ptr), VALUE :: c
     end subroutine redis_test_set

     subroutine iarray_to_redis(f, dims, ndims) bind ( c )
       use iso_c_binding
       integer(c_int) f(*), dims(*), ndims
     end subroutine iarray_to_redis

     type(c_ptr) function setup_connection() bind(c, name='setupConnection')
       use iso_c_binding
     end function setup_connection

     subroutine free_connection(c) bind(c, name='redisFree')
       use iso_c_binding
       type(c_ptr), VALUE :: c
     end subroutine free_connection

     subroutine c_redis_push(c, key, arr, dtype, dims, ndims) &
          bind(c, name='Redis_push')
       use iso_c_binding
       type(c_ptr), VALUE :: c, arr
       character(c_char) :: dtype(*), key(*)
       integer(c_int), VALUE :: ndims
       integer(c_int) :: dims(ndims)
     end subroutine c_redis_push
  end interface

contains

  subroutine array_to_redis(f)
    integer(c_int) f(:,:)
    integer(c_int) dims(2), ndims
    integer i

    ndims = 2
    do i=1,ndims
       dims(i) = size(f,i)
    end do

    call iarray_to_redis(f, dims, ndims)

  end subroutine array_to_redis

  subroutine stream_data(f)
    integer(c_int) :: f(:,:)
    integer(c_int) :: n, m
    external publish_to_redis
    ! TODO this is a function stub
    n = size(f, 1)
    m = size(f, 2)

    call publish_to_redis(f, n, m)

  end subroutine stream_data

  subroutine redis_push(c, key, arr, dtype, dims)
    use iso_c_binding
    type(c_ptr) :: c
    ! This next declaration is hacky way to make a fortran function polymorphic
    type(*), target :: arr(*)
    character(len=*) :: dtype, key
    integer(c_int) :: dims(:)

    character(len=128) :: dtype_c
    character(len=128) :: key_c

    ! strings in C need to be null-terminated
    dtype_c = (trim(dtype)//CHAR(0))
    key_c = (trim(key)//CHAR(0))

    call c_redis_push(c, key_c, c_loc(arr), dtype_c, dims, size(dims,1))
  end subroutine redis_push

end module redis_mod
