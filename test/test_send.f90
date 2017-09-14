program name
  use redis_mod, only: array_to_redis
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
end program name
