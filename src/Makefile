
CFLAGS += -I/usr/local/include/hiredis -I/usr/include/hiredis -g



libgeostreams.so: redis_wrapper.c
	 gcc $(CFLAGS) -fPIC -o $@ -c $^

