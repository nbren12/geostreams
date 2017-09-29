PROGRAM name
  USE redis_mod
  IMPLICIT NONE
  INTEGER, PARAMETER ::n=200, m=100
  REAL*4 :: f4(n,m)
  REAL*8 :: f8(n,m)
  INTEGER*2 :: i2(n,m)
  INTEGER*4 :: i4(n,m)
  INTEGER ndims
  INTEGER i, j

  TYPE (c_ptr) :: redis

  redis = setup_connection()

  ! initialize arrays
  DO j=1,m
     DO i=1,n
        f4(i,j) = i + .5
        f8(i,j) = i + .5
        i2(i,j) = i
        i4(i,j) = i
     END DO
  END DO

  ndims = 2

  ! top level API
  CALL redis_push(redis, 'A-f4', f4)
  CALL redis_push(redis, 'A-f8', f8)
  CALL redis_push(redis, 'A-i2', i2)
  CALL redis_push(redis, 'A-i4', i4)

  ! Lower level API
  CALL redis_push_explicit(redis, 'A-f4-explicit', f4, '<f4', shape(f4))
  CALL redis_push_explicit(redis, 'A-f8-explicit', f8, '<f4', shape(f8))
  CALL redis_push_explicit(redis, 'A-i2-explicit', i2, '<f4', shape(i2))
  CALL redis_push_explicit(redis, 'A-i4-explicit', i4, '<f4', shape(i4))

  CALL free_connection(redis)
END PROGRAM name
