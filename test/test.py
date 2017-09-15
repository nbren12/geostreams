import os
import time
from subprocess import Popen, DEVNULL
import imp
import unittest
import uuid

import numpy.testing


class ArrayTest(unittest.TestCase):
    def setUp(self):
        port = "6377"
        print(f"Starting a Redis server on {port}")
        self.redis_task = Popen(["redis-server", "--port", port], stdout=DEVNULL, stderr=DEVNULL)

        try:
            del os.environ['REDIS_PW']
        except KeyError:
            pass
        os.environ['REDIS_URL'] = "127.0.0.1" 
        os.environ['REDIS_PORT'] = port

        self.env = os.environ.copy()
        
    def tearDown(self):
        client = imp.load_source('client', '../src/client.py')
        print("Killing Server Task")
        # wait a little while for the process to die
        with client.gol_connection() as r:
            r.shutdown()
  
    def test_read_from_redis(self):
        client = imp.load_source('client', '../src/client.py')
        key = 'A:1'
	
        Popen(['./test_send'], env=self.env).wait()

        # 200 rows, 100 columns
        array = client.read_from_redis(key)
        x, _ = numpy.mgrid[1:201, 1:101]
        numpy.testing.assert_array_equal(
            x,
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
