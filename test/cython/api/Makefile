PYTHONPREFIX=$(shell python3.6-config --prefix)

LDFLAGS= -Wl,-rpath,$(PYTHONPREFIX)/lib \
	-L$(PYTHONPREFIX)/lib \
	$(shell python3.6-config --ldflags) 

CFLAGS = $(shell python3.6-config --cflags)



main:  main.c
	python setup.py build_ext --inplace
	$(CC) $(CFLAGS) $^ -o$@ $(LDFLAGS)
