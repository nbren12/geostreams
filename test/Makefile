FC = gfortran
LDFLAGS = -lhiredis
FFLAGS = -g  


all : test_send test
test: test_send
	./test_send
	python3 -m unittest test.py

redis_wrapper.o: redis_wrapper.c
	$(CC) $(CFLAGS) -I/usr/include/hiredis -c $^

test_send:   redis_mod.f90 test_send.f90 redis_wrapper.o
	$(FC)  $(FFLAGS) -o $@ $^ $(LDFLAGS)


clean:
	@ rm -f game_of_life game_of_life_openmp game_of_life_mpi main
	@ rm -f *.o
