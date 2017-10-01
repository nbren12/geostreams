import io
import numpy as np


def arr_to_dict(arr):
    return {'messages': arr.tostring(order='F'),
            'dtype': arr.__array_interface__['typestr'],
            'dimensions': ','.join("%d"%n for n in arr.shape)}



def redis_set(r, key, arr):
    r.hmset(key, arr_to_dict(arr))
