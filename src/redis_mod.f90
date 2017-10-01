module redis_mod
  use iso_c_binding
  implicit none

  character(len=1), parameter :: nullchar=char(0)

  interface

     function usleep(n) bind(c)
       use iso_c_binding
       integer(c_int), value :: n
       integer(c_int) usleep
     end function usleep

     subroutine redis_test_set(c) bind(c, name='redisTestSet')
       use iso_c_binding
       ! Arguments
       type(c_ptr), value :: c
     end subroutine redis_test_set

     type(c_ptr) function setup_connection() bind(c, name='setupConnection')
       use iso_c_binding
     end function setup_connection

     subroutine free_connection(c) bind(c, name='redisFree')
       use iso_c_binding
       ! Arguments
       type(c_ptr), value :: c
     end subroutine free_connection

     subroutine c_redis_push(c, key, arr, dtype, dims, ndims) &
          bind(c, name='Redis_push')
       use iso_c_binding
       ! Arguments
       type(c_ptr), value    :: c, arr
       character(c_char)     :: dtype(*), key(*)
       integer(c_int), value :: ndims
       integer(c_int)        :: dims(ndims)
     end subroutine c_redis_push

     function c_redis_incr(c, key) result(y) bind(c, name='Redis_incr')
       use iso_c_binding
       type(c_ptr), value    :: c
       character(c_char)     :: key(*)
       integer(c_long_long) :: y
     end function c_redis_incr

     function c_redis_uniq(c) result(y) bind(c, name='Redis_uniq')
       use iso_c_binding
       type(c_ptr), value    :: c
       integer(c_long_long) :: y
     end function c_redis_uniq

     subroutine c_redis_pub(c, channel, key) &
          bind(c, name='Redis_pub')
       use iso_c_binding
       type(c_ptr), value    :: c
       character(c_char)     :: channel(*), key(*)
     end subroutine c_redis_pub

  end interface

  interface redis_push
     module procedure redis_push_f4_1d, redis_push_f4_2d, redis_push_f4_3d, &
          redis_push_f8_1d, redis_push_f8_2d, redis_push_f8_3d, &
          redis_push_i2_1d, redis_push_i2_2d, redis_push_i2_3d, &
          redis_push_i4_1d, redis_push_i4_2d, redis_push_i4_3d
  end interface redis_push

contains

  function redis_uniq(c)
    ! Get uniq key using incr
    type(c_ptr)  :: c
    character(len=20) :: redis_uniq
    character(len=3) :: fmt
    write(redis_uniq,'(I0)') c_redis_uniq(c)
  end function redis_uniq

  subroutine redis_pub (c, channel, key)
    type(c_ptr)  :: c
    character(len=*) :: channel, key
    character(len=255) :: channel_c, key_c

    channel_c = trim(channel)//nullchar
    key_c = trim(key)//nullchar

    call c_redis_pub(c, channel_c, key_c)
  end subroutine redis_pub

  subroutine redis_push_f4_1d(c, key, arr)
    ! Push data to redis server (single precision)
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY(REAL*4)
    !     4-Byte floating point array
    use iso_c_binding
    ! Arguments
    type(c_ptr), intent(in)                  :: c
    real*4, dimension(:), target, intent(in) :: arr
    character(len=*), intent(in)             :: key
    ! Local Variables
    character(len=3)                         :: dtype

    ! array type
    dtype = endian()//"f4"

    ! Publish via explicit form
    call redis_push_explicit(c, key, arr, dtype, shape(arr))
  end subroutine redis_push_f4_1d


  subroutine redis_push_f4_2d(c, key, arr)
    ! Push data to redis server (single precision)
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY(REAL*4)
    !     4-Byte floating point array
    use iso_c_binding
    ! Arguments
    type(c_ptr), intent(in)                     :: c
    real*4, dimension(:, :), target, intent(in) :: arr
    character(len=*), intent(in)                :: key
    ! Local Variables
    character(len=3)                            :: dtype

    ! array type
    dtype = endian()//"f4"

    ! Publish via explicit form!
    call redis_push_explicit(c, key, arr, dtype, shape(arr))
  end subroutine redis_push_f4_2d


  subroutine redis_push_f4_3d(c, key, arr)
    ! Push data to redis server (single precision)
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY(REAL*4)
    !     4-Byte floating point array
    use iso_c_binding
    ! Arguments
    type(c_ptr), intent(in)                        :: c
    real*4, dimension(:, :, :), target, intent(in) :: arr
    character(len=*), intent(in)                   :: key
    ! Local Variables
    character(len=3)                               :: dtype

    ! array type
    dtype = endian()//"f4"

    ! Publish via explicit form!
    call redis_push_explicit(c, key, arr, dtype, shape(arr))
  end subroutine redis_push_f4_3d

  subroutine redis_push_f8_1d(c, key, arr)
    ! Push data to redis server (double precision)
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY(REAL*8)
    !     8-Byte floating point array
    use iso_c_binding
    ! Arguments
    type(c_ptr), intent(in)                  :: c
    real*8, dimension(:), target, intent(in) :: arr
    character(len=*), intent(in)             :: key
    ! Local Variables
    character(len=3)                         :: dtype

    ! array type
    dtype = endian()//"f8"

    ! Publish via explicit form
    call redis_push_explicit(c, key, arr, dtype, shape(arr))
  end subroutine redis_push_f8_1d


  subroutine redis_push_f8_2d(c, key, arr)
    ! Push data to redis server (double precision)
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY(REAL*8)
    !     8-Byte floating point array
    use iso_c_binding
    ! Arguments
    type(c_ptr), intent(in)                     :: c
    real*8, dimension(:, :), target, intent(in) :: arr
    character(len=*), intent(in)                :: key
    ! Local Variables
    character(len=3)                            :: dtype

    ! array type
    dtype = endian()//"f8"

    ! Publish via explicit form!
    call redis_push_explicit(c, key, arr, dtype, shape(arr))
  end subroutine redis_push_f8_2d


  subroutine redis_push_f8_3d(c, key, arr)
    ! Push data to redis server (double precision)
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY(REAL*8)
    !     8-Byte floating point array
    use iso_c_binding
    ! Arguments
    type(c_ptr), intent(in)                        :: c
    real*8, dimension(:, :, :), target, intent(in) :: arr
    character(len=*), intent(in)                   :: key
    ! Local Variables
    character(len=3)                               :: dtype

    ! array type
    dtype = endian()//"f8"

    ! Publish via explicit form!
    call redis_push_explicit(c, key, arr, dtype, shape(arr))
  end subroutine redis_push_f8_3d


  subroutine redis_push_i2_1d(c, key, arr)
    ! Push data to redis server (short int)
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY(INTEGER*2)
    !     2-Byte integer array
    use iso_c_binding
    ! Arguments
    type(c_ptr), intent(in)                     :: c
    integer*2, dimension(:), target, intent(in) :: arr
    character(len=*), intent(in)                :: key
    ! Local Variables
    character(len=3)                            :: dtype

    ! array type
    dtype = endian()//"i2"

    ! Publish via explicit form
    call redis_push_explicit(c, key, arr, dtype, shape(arr))
  end subroutine redis_push_i2_1d


  subroutine redis_push_i2_2d(c, key, arr)
    ! Push data to redis server (short int)
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY(INTEGER*2)
    !     2-Byte integer array
    use iso_c_binding
    ! Arguments
    type(c_ptr), intent(in)                        :: c
    integer*2, dimension(:, :), target, intent(in) :: arr
    character(len=*), intent(in)                   :: key
    ! Local Variables
    character(len=3)                               :: dtype

    ! array type
    dtype = endian()//"i2"

    ! Publish via explicit form
    call redis_push_explicit(c, key, arr, dtype, shape(arr))
  end subroutine redis_push_i2_2d


  subroutine redis_push_i2_3d(c, key, arr)
    ! Push data to redis server (short int)
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY(INTEGER*2)
    !     2-Byte integer array
    use iso_c_binding
    ! Arguments
    type(c_ptr), intent(in)                           :: c
    integer*2, dimension(:, :, :), target, intent(in) :: arr
    character(len=*), intent(in)                      :: key
    ! Local Variables
    character(len=3)                                  :: dtype

    ! array type
    dtype = endian()//"i2"

    ! Publish via explicit form
    call redis_push_explicit(c, key, arr, dtype, shape(arr))
  end subroutine redis_push_i2_3d


  subroutine redis_push_i4_1d(c, key, arr)
    ! Push data to redis server (long int)
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY(INTEGER*4)
    !     4-Byte integer array
    use iso_c_binding
    ! Arguments
    type(c_ptr), intent(in)                     :: c
    integer*4, dimension(:), target, intent(in) :: arr
    character(len=*), intent(in)                :: key
    ! Local Variables
    character(len=3)                            :: dtype

    ! array type
    dtype = endian()//"i4"

    ! Publish via explicit form
    call redis_push_explicit(c, key, arr, dtype, shape(arr))
  end subroutine redis_push_i4_1d


  subroutine redis_push_i4_2d(c, key, arr)
    ! Push data to redis server (long int)
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY(INTEGER*4)
    !     4-Byte integer array
    use iso_c_binding
    ! Arguments
    type(c_ptr), intent(in)                        :: c
    integer*4, dimension(:, :), target, intent(in) :: arr
    character(len=*), intent(in)                   :: key
    ! Local Variables
    character(len=3)                               :: dtype

    ! array type
    dtype = endian()//"i4"

    ! Publish via explicit form
    call redis_push_explicit(c, key, arr, dtype, shape(arr))
  end subroutine redis_push_i4_2d


  subroutine redis_push_i4_3d(c, key, arr)
    ! Push data to redis server (long int)
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY(INTEGER*4)
    !     4-Byte integer array
    use iso_c_binding
    ! Arguments
    type(c_ptr), intent(in)                           :: c
    integer*4, dimension(:, :, :), target, intent(in) :: arr
    character(len=*), intent(in)                      :: key
    ! Local Variables
    character(len=3)                                  :: dtype

    ! array type
    dtype = endian()//"i4"

    ! Publish via explicit form
    call redis_push_explicit(c, key, arr, dtype, shape(arr))
  end subroutine redis_push_i4_3d


  subroutine redis_push_explicit(c, key, arr, dtype, dims)
    ! Push data to redis server, interfacing with C library
    !
    ! Inputs
    ! -------
    ! c : c_ptr
    !     Pointer to redisContext structure
    ! key : CHARACTER
    !     Redis key
    ! arr : ARRAY
    !     Flexible type ND-Array
    ! dtype : CHARACTER
    !     Character string describing the endianess/type of ``arr`` (e.g. <f8)
    ! dims : INTEGER
    !     Shape of ``arr``
    use iso_c_binding

    type(c_ptr)        :: c
    type(*), target    :: arr(*)  ! hacky way to make a fortran function polymorphic
    character(len=*)   :: dtype, key
    integer(c_int)     :: dims(:)

    character(len=4)   :: dtype_c  ! e.g. "<f8\0"
    character(len=128) :: key_c  ! e.g. "\0"

    ! strings in C need to be null-terminated
    dtype_c = trim(dtype)//nullchar
    key_c = trim(key)//nullchar

    ! call C interface
    call c_redis_push(c, key_c, c_loc(arr), dtype_c, dims, size(dims,1))
  end subroutine redis_push_explicit


  function endian() result(e)
    ! Determine native byte order
    !
    ! Returns
    ! -------
    ! endianess : character
    !     '>' if little-endian, '<' big-endian
    character(1) :: e
    logical      :: bigend

    bigend = ichar(transfer(1,'a')) == 0

    if (bigend) then
       e = '>'
    else
       e = '<'
    end if
  end function endian

end module redis_mod
