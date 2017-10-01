from functools import partial
import numpy as np
from zict import Func
from .client import Redis, read_from_redis


def numpy_redis_mapping():
    return Func(arr_to_dict, dict_to_arr, Redis())

def redis_dict(r):
    b = Func(r.hmset)
    return Func(r, partial(read_from_redis, r), partial(red))

def dict_to_arr(d):
    dimension = d[b'dimensions'].decode("utf-8")
    message = d[b'messages']
    dtype = d[b'dtype']
    x, y = tuple(int(num) for num in dimension.split(','))
    array = np.fromstring(message, dtype=dtype)
    return array.reshape((x, y), order='F')

def arr_to_dict(arr):
    return {'messages': arr.tostring(order='F'),
            'dtype': arr.__array_interface__['typestr'],
            'dimensions': ','.join("%d"%n for n in arr.shape)}



def redis_set(r, key, arr):
    r.hmset(key, arr_to_dict(arr))
