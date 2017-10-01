from unittest import TestCase
import numpy as np
import redis

from .client import (read_from_redis, Redis, numpy_redis_mapping,
                     redis_set)


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
        d['a'] = b"1234"
        assert d['a'] == b"1234"

        # put seq in
        d['b'] = (b"a", b"b", b"c")
        assert tuple(d['b'])  == (b"a", b"b", b"c")

        # put dict in
        di = {b"a": b"1", b"b": b"2"}
        d["c"] = di
        self.assertDictEqual(d["c"], di)


    def test_numpy_redis_mapping(self):
        d = numpy_redis_mapping()
        x = np.random.rand(100,100)

        d['x'] = x

        np.testing.assert_equal(d['x'], x)
