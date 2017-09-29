program test_uniq
  use redis_mod
  implicit none
  integer, parameter ::n=200, m=100
  real*4 :: f4(n,m)
  real*8 :: f8(n,m)
  integer*2 :: i2(n,m)
  integer*4 :: i4(n,m)
  integer ndims
  integer i, j
  character*20 :: key

  type (c_ptr) :: redis

  redis = setup_connection()
  i = 0
  do
     key =  redis_uniq(redis)
     call redis_pub(redis, 'test_pub_channel', key)
     call sleep(1)
  end do
  call free_connection(redis)
end program test_uniq
