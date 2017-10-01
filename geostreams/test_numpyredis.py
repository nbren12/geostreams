from unittest import TestCase
import numpy as np
import redis

from .numpyredis import *
from .client import read_from_redis, Redis


def test_numpyredis():
    r = redis.StrictRedis()

    x = np.random.rand(100,100)

    redis_set(r, "x", x)
    y = read_from_redis(r, "x")

    np.testing.assert_equal(x, y)


class ZictTests(TestCase):

    def test_zict_redis(self):

        # put string in
        d = Redis(redis.StrictRedis())
        d['a'] = "1234"
        assert d['a'] == "1234"

        # put seq in
        d['b'] = ("a", "b", "c")
        assert tuple(d['b'])  == ("a", "b", "c")

        # put dict in
        di = {"a": "1", "b": "2"}
        d["c"] = di
        self.assertDictEqual(d["c"], di)
