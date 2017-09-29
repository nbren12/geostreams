PROGRAM test_uniq
  USE redis_mod
  IMPLICIT NONE
  INTEGER, PARAMETER ::n=200, m=100
  REAL*4 :: f4(n,m)
  REAL*8 :: f8(n,m)
  INTEGER*2 :: i2(n,m)
  INTEGER*4 :: i4(n,m)
  INTEGER ndims
  INTEGER i, j
  character*20 :: key

  TYPE (c_ptr) :: redis

  redis = setup_connection()
  i = 0
  do
    key =  redis_uniq(redis)
    call redis_pub(redis, 'test_pub_channel', key)
    call sleep(1)
  end do
  CALL free_connection(redis)
END PROGRAM test_uniq
