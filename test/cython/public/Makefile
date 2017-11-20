PYTHONPREFIX=$(shell python3.6-config --prefix)

LDFLAGS= -Wl,-rpath,$(PYTHONPREFIX)/lib \
	-L$(PYTHONPREFIX)/lib \
	$(shell python3.6-config --ldflags) 

CFLAGS = $(shell python3.6-config --cflags)


%.c : %.pyx
	cythonize $^

test: cython_hook.o test.c
