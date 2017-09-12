
FFLAGS = -g


all: game_of_life game_of_life_openmp game_of_life_mpi

game_of_life: game_of_life.f90
	gfortran $(FFLAGS) -o $@ $<

game_of_life_openmp: game_of_life.f90
	gfortran $(FFLAGS) -fopenmp -o $@ $<

game_of_life_mpi: game_of_life_mpi.f90
	mpif90 $(FFLAGS) -o $@ $<

run_mpi: ./game_of_life_mpi
	mpiexec -n 4 ./game_of_life_mpi

clean:
	@ rm -f game_of_life game_of_life_openmp game_of_life_mpi
