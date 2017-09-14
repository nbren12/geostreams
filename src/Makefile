
INC += -I/usr/local/include/hiredis -I/usr/include/hiredis
CFLAGS = $(INC) -g

libgeostreams.a: redis_wrapper.o redis_mod.o
	ar rcs $@ $^

redis_mod.o : redis_mod.f90
	gfortran $(INC) -g -c $^

redis_wrapper.o: redis_wrapper.c
	 gcc $(CFLAGS) -c $^

