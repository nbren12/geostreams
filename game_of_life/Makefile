
FFLAGS = -g 
CFLAGS += -I/usr/local/include/hiredis


main: main.f90 redis.f90 redis_wrapper.o
	gfortran -lhiredis $(FFLAGS) -o $@ $^

# Target for all games of life
gols: game_of_life game_of_life_openmp game_of_life_mpi

game_of_life: game_of_life.f90 redis.f90 redis_wrapper.o
	gfortran -lhiredis $(FFLAGS) -o $@ $^

game_of_life_openmp: game_of_life.f90
	gfortran $(FFLAGS) -fopenmp -o $@ $^

game_of_life_mpi: game_of_life_mpi.f90
	mpif90 $(FFLAGS) -o $@ $<

run_mpi: ./game_of_life_mpi
	mpiexec -n 4 ./game_of_life_mpi

clean:
	@ rm -f game_of_life game_of_life_openmp game_of_life_mpi main
	@ rm -f *.o
