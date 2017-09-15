FC = gfortran
LDFLAGS =  -lgeostreams -lhiredis -L../src
FFLAGS = -g  


all : test_send test
test: test_send
	python3 -m unittest test.py


test_send:   redis_mod.f90 test_send.f90
	$(FC)  $(FFLAGS) -o $@ $^ $(LDFLAGS)


clean:
	@ rm -f game_of_life game_of_life_openmp game_of_life_mpi main
	@ rm -f *.o
