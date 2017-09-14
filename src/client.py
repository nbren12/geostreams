import os
import contextlib

import redis
import numpy
from matplotlib import pyplot


@contextlib.contextmanager
def gol_connection():
    connection = redis.StrictRedis(host="35.197.66.213", port=6379, db=0,
                                   password=os.environ['REDIS_PW'])
    yield connection


# TODO: use connection.pubsub to get a new array for each new scene sent to the
# queue
def read_from_redis(key):
    with gol_connection() as connection:
        record = connection.get(key)
        print record

        x, y = tuple(float(num) for num in record['dimension'].split(','))
        array = numpy.fromstring(record['message'], dtype='<i4').reshape((x, y))
        return array


def write_to_redis(key, array):
    with gol_connection() as connection:
        data = {
            'dimension': "%s,%s" % array.shape,
            'message': array.tostring('F')  # fortran order
        }
        connection.set(key, data)


# Read from the Game Of Life key/value pair.
def read_gol():
    with gol_connection() as connection:
        loaded_array = numpy.fromstring(connection.brpop('A'), dtype='<i4')
        array = loaded_array.reshape((100, 100))
        pyplot.imshow(array)
        pyplot.savefig('scene.png')
