
FFLAGS = -O3


all: game_of_life game_of_life_openmp

game_of_life: game_of_life.f90
	gfortran $(FFLAGS) -o $@ $<

game_of_life_openmp: game_of_life.f90
	gfortran $(FFLAGS) -fopenmp -o $@ $<


clean:
	@ rm -f game_of_life game_of_life_openmp
