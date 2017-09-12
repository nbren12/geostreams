module redis_mod
  use, intrinsic :: iso_c_binding
  implicit none

contains

  subroutine stream_data(f)
    integer(c_int) :: f(:,:)
    integer(c_int) :: n, m
    external publish_to_redis
    ! TODO this is a function stub
    n = size(f, 1)
    m = size(f, 2)

    call publish_to_redis(f, n, m)

  end subroutine stream_data

end module redis_mod
