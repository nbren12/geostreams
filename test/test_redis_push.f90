program name
  use redis_mod
  implicit none
  integer, parameter ::n=200, m=100
  integer :: dims(2)
  real :: f(n,m)
  integer ndims
  integer i, j

  type (c_ptr) :: redis

  redis = setup_connection()

  ! initialize array
  do j=1,m
    do i=1,n
      f(i,j) = i + .5
    end do
  end do

  ndims = 2

  call redis_push(redis, 'A', f, 'f4', shape(f))

  call free_connection(redis)
end program name
