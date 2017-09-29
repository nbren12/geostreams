MODULE redis_mod
  USE iso_c_binding
  IMPLICIT NONE

  CHARACTER(len=1), PARAMETER :: nullchar=CHAR(0)

  INTERFACE
     SUBROUTINE redis_test_set(c) bind(c, name='redisTestSet')
       USE iso_c_binding
       ! Arguments
       TYPE(c_ptr), VALUE :: c
     END SUBROUTINE redis_test_set

     TYPE(c_ptr) FUNCTION setup_connection() bind(c, name='setupConnection')
       USE iso_c_binding
     END FUNCTION setup_connection

     SUBROUTINE free_connection(c) bind(c, name='redisFree')
       USE iso_c_binding
       ! Arguments
       TYPE(c_ptr), VALUE :: c
     END SUBROUTINE free_connection

     SUBROUTINE c_redis_push(c, key, arr, dtype, dims, ndims) &
          bind(c, name='Redis_push')
       USE iso_c_binding
       ! Arguments
       TYPE(c_ptr), VALUE    :: c, arr
       CHARACTER(c_char)     :: dtype(*), key(*)
       INTEGER(c_int), VALUE :: ndims
       INTEGER(c_int)        :: dims(ndims)
     END SUBROUTINE c_redis_push

     FUNCTION c_redis_incr(c, key) result(y) bind(c, name='Redis_incr')
       use iso_c_binding
       TYPE(c_ptr), VALUE    :: c
       CHARACTER(c_char)     :: key(*)
       integer(c_long_long) :: y
     END FUNCTION c_redis_incr

     FUNCTION c_redis_uniq(c) result(y) bind(c, name='Redis_uniq')
       use iso_c_binding
       TYPE(c_ptr), VALUE    :: c
       integer(c_long_long) :: y
     END FUNCTION c_redis_uniq

  END INTERFACE

  INTERFACE redis_push
     MODULE PROCEDURE redis_push_f4_1d, redis_push_f4_2d, redis_push_f4_3d, &
          redis_push_f8_1d, redis_push_f8_2d, redis_push_f8_3d, &
          redis_push_i2_1d, redis_push_i2_2d, redis_push_i2_3d, &
          redis_push_i4_1d, redis_push_i4_2d, redis_push_i4_3d
  END INTERFACE redis_push

CONTAINS

  function redis_uniq(c)
    type(c_ptr)  :: c
    character(len=20) :: redis_uniq
    character(len=3) :: fmt
    write(redis_uniq,'(I0)') c_redis_uniq(c)
  end function redis_uniq

  SUBROUTINE redis_push_f4_1d(c, key, arr)
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
    USE iso_c_binding
    ! Arguments
    TYPE(c_ptr), INTENT(in)                  :: c
    REAL*4, DIMENSION(:), TARGET, INTENT(in) :: arr
    CHARACTER(len=*), INTENT(in)             :: key
    ! Local Variables
    CHARACTER(len=3)                         :: dtype

    ! array type
    dtype = endian()//"f4"

    ! Publish via explicit form
    CALL redis_push_explicit(c, key, arr, dtype, SHAPE(arr))
  END SUBROUTINE redis_push_f4_1d


  SUBROUTINE redis_push_f4_2d(c, key, arr)
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
    USE iso_c_binding
    ! Arguments
    TYPE(c_ptr), INTENT(in)                     :: c
    REAL*4, DIMENSION(:, :), TARGET, INTENT(in) :: arr
    CHARACTER(len=*), INTENT(in)                :: key
    ! Local Variables
    CHARACTER(len=3)                            :: dtype

    ! array type
    dtype = endian()//"f4"

    ! Publish via explicit form!
    CALL redis_push_explicit(c, key, arr, dtype, SHAPE(arr))
  END SUBROUTINE redis_push_f4_2d


  SUBROUTINE redis_push_f4_3d(c, key, arr)
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
    USE iso_c_binding
    ! Arguments
    TYPE(c_ptr), INTENT(in)                        :: c
    REAL*4, DIMENSION(:, :, :), TARGET, INTENT(in) :: arr
    CHARACTER(len=*), INTENT(in)                   :: key
    ! Local Variables
    CHARACTER(len=3)                               :: dtype

    ! array type
    dtype = endian()//"f4"

    ! Publish via explicit form!
    CALL redis_push_explicit(c, key, arr, dtype, SHAPE(arr))
  END SUBROUTINE redis_push_f4_3d

  SUBROUTINE redis_push_f8_1d(c, key, arr)
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
    USE iso_c_binding
    ! Arguments
    TYPE(c_ptr), INTENT(in)                  :: c
    REAL*8, DIMENSION(:), TARGET, INTENT(in) :: arr
    CHARACTER(len=*), INTENT(in)             :: key
    ! Local Variables
    CHARACTER(len=3)                         :: dtype

    ! array type
    dtype = endian()//"f8"

    ! Publish via explicit form
    CALL redis_push_explicit(c, key, arr, dtype, SHAPE(arr))
  END SUBROUTINE redis_push_f8_1d


  SUBROUTINE redis_push_f8_2d(c, key, arr)
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
    USE iso_c_binding
    ! Arguments
    TYPE(c_ptr), INTENT(in)                     :: c
    REAL*8, DIMENSION(:, :), TARGET, INTENT(in) :: arr
    CHARACTER(len=*), INTENT(in)                :: key
    ! Local Variables
    CHARACTER(len=3)                            :: dtype

    ! array type
    dtype = endian()//"f8"

    ! Publish via explicit form!
    CALL redis_push_explicit(c, key, arr, dtype, SHAPE(arr))
  END SUBROUTINE redis_push_f8_2d


  SUBROUTINE redis_push_f8_3d(c, key, arr)
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
    USE iso_c_binding
    ! Arguments
    TYPE(c_ptr), INTENT(in)                        :: c
    REAL*8, DIMENSION(:, :, :), TARGET, INTENT(in) :: arr
    CHARACTER(len=*), INTENT(in)                   :: key
    ! Local Variables
    CHARACTER(len=3)                               :: dtype

    ! array type
    dtype = endian()//"f8"

    ! Publish via explicit form!
    CALL redis_push_explicit(c, key, arr, dtype, SHAPE(arr))
  END SUBROUTINE redis_push_f8_3d


  SUBROUTINE redis_push_i2_1d(c, key, arr)
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
    USE iso_c_binding
    ! Arguments
    TYPE(c_ptr), INTENT(in)                     :: c
    INTEGER*2, DIMENSION(:), TARGET, INTENT(in) :: arr
    CHARACTER(len=*), INTENT(in)                :: key
    ! Local Variables
    CHARACTER(len=3)                            :: dtype

    ! array type
    dtype = endian()//"i2"

    ! Publish via explicit form
    CALL redis_push_explicit(c, key, arr, dtype, SHAPE(arr))
  END SUBROUTINE redis_push_i2_1d


  SUBROUTINE redis_push_i2_2d(c, key, arr)
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
    USE iso_c_binding
    ! Arguments
    TYPE(c_ptr), INTENT(in)                        :: c
    INTEGER*2, DIMENSION(:, :), TARGET, INTENT(in) :: arr
    CHARACTER(len=*), INTENT(in)                   :: key
    ! Local Variables
    CHARACTER(len=3)                               :: dtype

    ! array type
    dtype = endian()//"i2"

    ! Publish via explicit form
    CALL redis_push_explicit(c, key, arr, dtype, SHAPE(arr))
  END SUBROUTINE redis_push_i2_2d


  SUBROUTINE redis_push_i2_3d(c, key, arr)
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
    USE iso_c_binding
    ! Arguments
    TYPE(c_ptr), INTENT(in)                           :: c
    INTEGER*2, DIMENSION(:, :, :), TARGET, INTENT(in) :: arr
    CHARACTER(len=*), INTENT(in)                      :: key
    ! Local Variables
    CHARACTER(len=3)                                  :: dtype

    ! array type
    dtype = endian()//"i2"

    ! Publish via explicit form
    CALL redis_push_explicit(c, key, arr, dtype, SHAPE(arr))
  END SUBROUTINE redis_push_i2_3d


  SUBROUTINE redis_push_i4_1d(c, key, arr)
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
    USE iso_c_binding
    ! Arguments
    TYPE(c_ptr), INTENT(in)                     :: c
    INTEGER*4, DIMENSION(:), TARGET, INTENT(in) :: arr
    CHARACTER(len=*), INTENT(in)                :: key
    ! Local Variables
    CHARACTER(len=3)                            :: dtype

    ! array type
    dtype = endian()//"i4"

    ! Publish via explicit form
    CALL redis_push_explicit(c, key, arr, dtype, SHAPE(arr))
  END SUBROUTINE redis_push_i4_1d


  SUBROUTINE redis_push_i4_2d(c, key, arr)
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
    USE iso_c_binding
    ! Arguments
    TYPE(c_ptr), INTENT(in)                        :: c
    INTEGER*4, DIMENSION(:, :), TARGET, INTENT(in) :: arr
    CHARACTER(len=*), INTENT(in)                   :: key
    ! Local Variables
    CHARACTER(len=3)                               :: dtype

    ! array type
    dtype = endian()//"i4"

    ! Publish via explicit form
    CALL redis_push_explicit(c, key, arr, dtype, SHAPE(arr))
  END SUBROUTINE redis_push_i4_2d


  SUBROUTINE redis_push_i4_3d(c, key, arr)
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
    USE iso_c_binding
    ! Arguments
    TYPE(c_ptr), INTENT(in)                           :: c
    INTEGER*4, DIMENSION(:, :, :), TARGET, INTENT(in) :: arr
    CHARACTER(len=*), INTENT(in)                      :: key
    ! Local Variables
    CHARACTER(len=3)                                  :: dtype

    ! array type
    dtype = endian()//"i4"

    ! Publish via explicit form
    CALL redis_push_explicit(c, key, arr, dtype, SHAPE(arr))
  END SUBROUTINE redis_push_i4_3d


  SUBROUTINE redis_push_explicit(c, key, arr, dtype, dims)
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
    USE iso_c_binding

    TYPE(c_ptr)        :: c
    TYPE(*), TARGET    :: arr(*)  ! hacky way to make a fortran function polymorphic
    CHARACTER(len=*)   :: dtype, key
    INTEGER(c_int)     :: dims(:)

    CHARACTER(len=4)   :: dtype_c  ! e.g. "<f8\0"
    CHARACTER(len=128) :: key_c  ! e.g. "\0"

    ! strings in C need to be null-terminated
    dtype_c = TRIM(dtype)//nullchar
    key_c = TRIM(key)//nullchar

    ! call C interface
    CALL c_redis_push(c, key_c, c_loc(arr), dtype_c, dims, SIZE(dims,1))
  END SUBROUTINE redis_push_explicit


  FUNCTION endian() RESULT(e)
    ! Determine native byte order
    !
    ! Returns
    ! -------
    ! endianess : character
    !     '>' if little-endian, '<' big-endian
    CHARACTER(1) :: e
    LOGICAL      :: bigend

    bigend = ICHAR(TRANSFER(1,'a')) == 0

    IF (bigend) THEN
       e = '>'
    ELSE
       e = '<'
    END IF
  END FUNCTION endian

END MODULE redis_mod
