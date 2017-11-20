# delorean.pyx 
cdef api struct Vehicle: 
    int speed 
    float power 

cdef api void activate(): 

    print( "Time travel achieved")
