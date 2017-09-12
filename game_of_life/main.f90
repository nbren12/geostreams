program name
  use redis_mod
  implicit none
  integer, parameter ::n=100, m=100
  integer f(n,m)

  print *, "Hello from fortran"
  call stream_data(f)

end program name
