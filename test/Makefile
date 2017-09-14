
LDFLAGS = -lgeostreams -L../src -lhiredis
FFLAGS = -g  


all : test_send test
test: test_send
	./test_send

test_send: test_send.f90
	gfortran $(LDFLAGS) $(FFLAGS) -o $@ $^


clean:
	@ rm -f game_of_life game_of_life_openmp game_of_life_mpi main
	@ rm -f *.o
