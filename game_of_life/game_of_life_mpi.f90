! See Conways game of life on wikipedia
! https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
program conways_game_of_life
  use mpi
  implicit none
  integer, parameter :: ALIVE=1, DEAD=0
  integer, allocatable :: f(:,:), g(:,:)
  integer n, samples, t
  integer rank, nproc, ierr, tag, status(MPI_STATUS_SIZE)
  integer nproc_x, nproc_y
  integer :: dims(2), ndims
  logical :: periods(2), reorder
  integer :: cart_comm


  call MPI_INIT(ierr)
  call MPI_Comm_Size(MPI_COMM_WORLD, nproc, ierr)
  call MPI_Comm_Rank(MPI_COMM_WORLD, rank, ierr)


  ! create cart comm
  nproc_x = 2
  nproc_y = 2

  if (rank .ne. nproc_x * nproc_y) then
     if (rank == 1) print *, 'Rank must be 4...stopping execution'
     call MPI_Barrier(MPI_COMM_WORLD, ierr)
     stop -1
  end if

  ndims = 2
  dims = (/nproc_x, nproc_y/)
  periods = (/.true., .true./)
  reorder = .false.
  call MPI_Cart_create(MPI_COMM_WORLD, ndims, dims, periods, reorder, cart_comm, ierr)

  ! get input from command line
  read(11, *) n, samples

  if (rank == 1) then

     print*, 'node', rank, ' of ', nproc
     print *, 'ngrid=', n
     print *, 'samples=', samples
  end if

  ! allocate solution arrays
  allocate(f(0:n+1,0:n+1))
  allocate(g(0:n+1,0:n+1))

  call init(f)

  ! time loop
  do t=1,samples
     call stream_data(f)
     call periodic_bc(f)
     call advance(f, g)

     call stream_data(g)
     call periodic_bc(g)
     call advance(g, f)
  end do

  call stream_data(f)

  call MPI_Finalize(ierr)

contains
  subroutine advance(f, g)
    integer :: f(0:, 0:), g(0:, 0:)
    integer i, j
    integer n
    ! fortran is column major, so first dimension is contiguous in memory
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
  end subroutine advance


  subroutine comm(sbuf, rbuf, n, direc, disp)
    integer :: rank_source, rank_dest, direc, disp, n
    integer :: sbuf(n) ! for mpi sends
    integer :: rbuf(n) ! for mpi recv



    call MPI_Cart_shift(cart_comm, direc, disp, rank_source, rank_dest, ierr)
    if (rank == 0) then
       print *, 'recv', rank_source, 'send', rank_dest
    end if
    call MPI_Sendrecv(sbuf, n, MPI_INTEGER,&
         rank_dest, 0,&
         rbuf, n, Mpi_Integer,&
         rank_source, 0,&
         cart_comm, status,&
         ierr)

  end subroutine comm

  subroutine periodic_bc(phi)
    integer :: phi(:,:)
    integer :: sbuf(size(phi,1)) ! for mpi sends
    integer :: rbuf(size(phi,1)) ! for mpi recv
    integer :: n,g,i,j
    n = size(phi,2)

    sbuf = phi(2,:)
    call comm(sbuf, rbuf, n, 0, -1)
    phi(n,:) = rbuf

    sbuf = phi(n-1,:)
    call comm(sbuf, rbuf, n, 0, 1)
    phi(1,:) = rbuf


    sbuf = phi(:, 2)
    call comm(sbuf, rbuf, n, 1, -1)
    phi(:, n) = rbuf

    sbuf = phi(:, n-1)
    call comm(sbuf, rbuf, n, 1, 1)
    phi(:, 1) = rbuf

  end subroutine periodic_bc


  subroutine init(f)
    integer f(:,:), i, j
    real ran

    f = DEAD

    do j=lbound(f,2),ubound(f,2)
       do i=lbound(f,1),ubound(f,1)
          call random_number(ran)
          if (ran < .3) f(i,j) = ALIVE
       end do
    end do

  end subroutine init

  subroutine stream_data(f)
    integer f(:,:)
    ! TODO this is a function stub
  end subroutine stream_data

end program
