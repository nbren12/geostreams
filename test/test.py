import imp
import unittest
import uuid

import numpy


class ArrayTest(unittest.TestCase):
    def test_read_from_redis(self):
        client = imp.load_source('client', '../src/client.py')
        key = 'A:1'

        # 200 rows, 100 columns
        array = client.read_from_redis(key)
        numpy.assert_arrays_equal(
            numpy.tile(numpy.arange(100).reshape((100, 1)), (1, 200)),
            array)

    def test_write_to_redis(self):
        client = imp.load_source('client', '../src/client.py')
        key = str(uuid.uuid4())

        try:
            array = numpy.tile(numpy.arange(100).reshape((100, 1)), (1, 200))
            client.write_to_redis(key, array)
        finally:
            with client.gol_connection() as connection:
                connection.delete(key)
