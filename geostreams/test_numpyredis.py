import numpy as np
import redis

from .numpyredis import *
from .client import read_from_redis


def test_numpyredis():
    r = redis.StrictRedis()

    x = np.random.rand(100,100)

    redis_set(r, "x", x)
    y = read_from_redis(r, "x")

    np.testing.assert_equal(x, y)
