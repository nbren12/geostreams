
INC += -I/usr/include/hiredis
FFLAGS = -g  $(INC)
LDFLAGS =  -lgfortran -lgeostreams -lhiredis -L../src
CFLAGS += $(INC)

all: game_of_life

main: main.f90 redis.o
	gfortran -lhiredis $(FFLAGS) -o $@ $^

%.o : %.f90
	gfortran -c $(FFLAGS) -c $^

game_of_life: game_of_life.f90 redis.o
	gfortran $(FFLAGS) -o $@ $^ $(LDFLAGS)

game_of_life_openmp: game_of_life.f90 redis.o
	gfortran $(FFLAGS) -fopenmp -o $@ $^

game_of_life_mpi: game_of_life_mpi.f90 redis.o
	mpif90 $(FFLAGS) -o $@ $<

run_mpi: ./game_of_life_mpi
	mpiexec -n 4 ./game_of_life_mpi

clean:
	@ rm -f game_of_life game_of_life_openmp game_of_life_mpi main
	@ rm -f *.o
