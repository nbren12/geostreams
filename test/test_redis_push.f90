program name
  use redis_mod
  implicit none
  integer, parameter ::n=200, m=100
  real*4 :: f4(n,m)
  real*8 :: f8(n,m)
  integer*2 :: i2(n,m)
  integer*4 :: i4(n,m)
  integer ndims
  integer i, j

  type (c_ptr) :: redis

  redis = setup_connection()

  ! initialize arrays
  do j=1,m
     do i=1,n
        f4(i,j) = i + .5
        f8(i,j) = i + .5
        i2(i,j) = i
        i4(i,j) = i
     end do
  end do

  ndims = 2

  ! top level API
  call redis_push(redis, 'A-f4', f4)
  call redis_push(redis, 'A-f8', f8)
  call redis_push(redis, 'A-i2', i2)
  call redis_push(redis, 'A-i4', i4)

  ! Lower level API
  call redis_push_explicit(redis, 'A-f4-explicit', f4, '<f4', shape(f4))
  call redis_push_explicit(redis, 'A-f8-explicit', f8, '<f4', shape(f8))
  call redis_push_explicit(redis, 'A-i2-explicit', i2, '<f4', shape(i2))
  call redis_push_explicit(redis, 'A-i4-explicit', i4, '<f4', shape(i4))

  call free_connection(redis)
end program name
