
CFLAGS += -I/usr/local/include/hiredis -I/usr/include/hiredis -g


main: main.f90 redis.o redis_wrapper.o
	gfortran -lhiredis $(FFLAGS) -o $@ $^

libgeostreams.so: redis_wrapper.c
	 gcc $(CFLAGS) -fPIC -o $@ -c $^

