import os
import contextlib

import redis
import numpy
from matplotlib import pyplot


@contextlib.contextmanager
def gol_connection():
    connection = redis.StrictRedis(host=os.environ['REDIS_HOST'],
                                   port=os.environ['REDIS_PORT'],
                                   db=0,
                                   password=os.environ['REDIS_PW'])
    yield connection


# TODO: use connection.pubsub to get a new array for each new scene sent to the
# queue
def read_from_redis(key):
    with gol_connection() as connection:
        dimension = connection.hget(key, 'dimensions')
        message = connection.hget(key, 'message')  # nothing returned from this yet.

        x, y = tuple(float(num) for num in dimension.split(','))
        array = numpy.fromstring(message, dtype='<i4').reshape((x, y))
        return array


def write_to_redis(key, array):
    with gol_connection() as connection:
        data = {
            'dimension': "%s,%s" % array.shape,
            'message': array.tostring('F')  # fortran order
        }
        connection.lpush(key, data)


# Read from the Game Of Life key/value pair.
def read_gol():
    with gol_connection() as connection:
        if connection.exists('A'):
            loaded_array = numpy.fromstring(connection.brpop('A'), dtype='<i4')
            array = loaded_array.reshape((100, 100))
            pyplot.imshow(array)
            pyplot.savefig('scene.png')
        else:
            print('No key `A`.')
