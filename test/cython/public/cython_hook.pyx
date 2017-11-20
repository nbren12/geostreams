import numpy as np

cdef public cython_hook():
    hello()

def hello():
    for i in range(10):
        print(i, "hello")
