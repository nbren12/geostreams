! See Conways game of life on wikipedia
! https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
program conways_game_of_life
  use redis_mod
  implicit none
  integer, parameter :: ALIVE=1, DEAD=0
  integer, allocatable :: f(:,:)
  integer n, samples, t, cond
  integer ret
  character(len=20) :: key

  type (c_ptr) :: redis

  redis = setup_connection()

  ! get input from command line
  print *, 'Enter ngrid, nsamples'
  ! read(11, *) n, samples,cond

  print *, 'Enter number for initial condition'
  print *, '1 - Glider'
  print *, '2 - Box (Stationary)'
  print *, '3 - Random'
  !read *, cond

  n = 200
  samples = 100000000
  cond = 3

  print *, 'ngrid=', n
  print *, 'samples=', samples

  ! allocate solution arrays
  allocate(f(n,n))

  call init(f, cond)

  ! time loop
  t = 0
  do while ((t < samples ) .or. ( samples < 0))
     ret = usleep(100000)
     key = redis_uniq(redis)
     call redis_push(redis, key, f)
     call redis_pub(redis, 'game_of_life', key)
     call periodic_bc(f)
     call advance(f)
     t = t + 1
     print *, t
  end do

  call redis_push(redis, 'A', f)

contains
  subroutine advance(f)
    integer :: f(:, :)
    integer :: g(0:size(f,1)+1, 0:size(f,2)+1)
    integer i, j
    integer n, m
    ! fortran is column major, so first dimension is contiguous in memory
    !$omp parallel do private(i,j,n)
    m = size(f,1)

    ! fill in boundary conditions
    g(1:m, 1:m) = f
    call periodic_bc(g)

    do j=1,m
       do i=1,m
          n = sum(g(i-1:i+1,j-1:j+1)) - g(i,j)
          ! conways rules
          select case(g(i,j))
          case(ALIVE)
             ! death by underpopulation/overopulation
             if ((n < 2) .or. (n > 3)) f(i,j) = DEAD
          case(DEAD)
             if (n==3) f(i,j) = ALIVE
          end select
       end do
    end do
    !$omp end parallel do

  end subroutine advance

  subroutine periodic_bc(phi)
    integer :: phi(0:,0:)
    integer n, m
    m = ubound(phi,1) - 1
    n = ubound(phi,2) - 1

    ! This fills in the corners automatically
    phi(0,:) = phi(m,:)
    phi(m+1,:) = phi(1,:)
    phi(:,0) = phi(:,m)
    phi(:,m+1) = phi(:,1)

  end subroutine periodic_bc


  subroutine init(f, cond)
    integer f(:,:), i, j, cond
    real ran
    integer window(3,3), i0, j0
    f = DEAD
    select case(cond)
    case(1)
       window(1,:) = (/0, 1, 0/)
       window(2,:) = (/0, 0, 1/)
       window(3,:) = (/1, 1, 1/)
       print *, 'Glider Condition!'

       do i=1,4
          do j=1,4
             i0 = 10*i + 140
             j0 = 10*j + 140
             f(i0-1:i0+1,j0-1:j0+1)  = window
          end do
       end do
    case(2)

       f(5,5:7) = (/0, 1, 1/)
       f(6,5:7) = (/0, 1, 1/)
       f(7,5:7) = (/0, 0, 0/)
       print *, 'Block condition!'
    case(3)

       do j=lbound(f,2),ubound(f,2)
          do i=lbound(f,1),ubound(f,1)
             call random_number(ran)
             if (ran < .3) f(i,j) = ALIVE
          end do
       end do
       print *, 'Random condition!'

    end select
  end subroutine init

  subroutine mysleep(n)
    real(8) buf
    integer n, i
    do i=1,n*10000
       call random_number(buf)
    end do
  end subroutine mysleep

end program conways_game_of_life
