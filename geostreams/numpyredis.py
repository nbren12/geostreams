from functools import partial
import numpy as np
from zict import Func
from .client import read_from_redis

def redis_dict(r):
    b = Func(r.hmset)
    return Func(r, partial(read_from_redis, r), partial(red))

def arr_to_dict(arr):
    return {'messages': arr.tostring(order='F'),
            'dtype': arr.__array_interface__['typestr'],
            'dimensions': ','.join("%d"%n for n in arr.shape)}



def redis_set(r, key, arr):
    r.hmset(key, arr_to_dict(arr))
