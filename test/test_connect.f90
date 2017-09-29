program name
  use redis_mod
  implicit none

  type(c_ptr) :: c

  c =  setup_connection()
  call redis_test_set(c)
  call free_connection(c)

end program name
