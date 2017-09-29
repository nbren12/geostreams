PROGRAM name
  USE redis_mod
  IMPLICIT NONE

  TYPE(c_ptr) :: c

  c =  setup_connection()
  CALL redis_test_set(c)
  CALL free_connection(c)

END PROGRAM name
