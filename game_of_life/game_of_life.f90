! See Conways game of life on wikipedia
! https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
program conways_game_of_life
  use redis_mod
  implicit none
  integer, parameter :: ALIVE=1, DEAD=0
  integer, allocatable :: f(:,:), g(:,:)
  integer n, samples, t

  ! get input from command line
  print *, 'Enter ngrid, nsamples'
  read(11, *) n, samples

  print *, 'ngrid=', n
  print *, 'samples=', samples

  ! allocate solution arrays
  allocate(f(0:n+1,0:n+1))
  allocate(g(0:n+1,0:n+1))

  call init(f)

  ! time loop
  t = 0
  do while ((t < samples ) .or. ( samples < 0))
     call stream_data(f)
     call periodic_bc(f, 1)
     call advance(f, g)
     t = t + 1

     call stream_data(g)
     call periodic_bc(g, 1)
     call advance(g, f)
     t = t + 1
  end do

  call stream_data(f)

contains
  subroutine advance(f, g)
    integer :: f(0:, 0:), g(0:, 0:)
    integer i, j
    integer n
    ! fortran is column major, so first dimension is contiguous in memory
    !$omp parallel do private(i,j,n)
    do j=1,ubound(f,2)-1
       do i=1,ubound(f,1)-1
          n = sum(f(i-1:i+1,j-1:j+1)) - 1
          ! conways rules
          select case(f(i,j))
          case(ALIVE)
             ! death by underpopulation/overopulation
             if ((n < 2) .or. (n > 3)) g(i,j) = DEAD
          case(DEAD)
             if (n==3) g(i,j) = ALIVE
          end select
       end do
    end do
    !$omp end parallel do

  end subroutine advance

  subroutine periodic_bc(phi, g)
    integer :: phi(:,:)
    integer n,g,i,j
    n = size(phi,2)


    do i=1,g
       do j=1,size(phi,1)
          phi(j,i) = phi(j,n-g-g+1)
          phi(j,n-g+i) = phi(j,g+i)
       end do
    end do

  end subroutine periodic_bc


  subroutine init(f)
    integer f(:,:), i, j
    real ran

    f = DEAD

    f(2,2:4) =(/0, 0, 1/)
    f(3,2:4) =(/1, 0, 1/)
    f(4,2:4) =(/0, 1, 1/)


  end subroutine init

end program
