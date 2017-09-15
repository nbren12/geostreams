CFLAGS += -I/usr/include/hiredis

libgeostreams.a: redis_wrapper.o
	ar rcs $@ $^ 

clean:
	@ rm -f game_of_life game_of_life_openmp game_of_life_mpi main
	@ rm -f *.o
