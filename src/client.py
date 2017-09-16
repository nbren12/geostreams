import os
import contextlib

import redis
import numpy


@contextlib.contextmanager
def gol_connection():

    url = os.environ.get('REDIS_URL', "127.0.0.1")
    port = os.environ.get('REDIS_URL', "6379")
    password = os.environ.get('REDIS_PW', None)

    print(f'Connecting to redis server at {url}:{port}' )
    connection = redis.StrictRedis(host=url,
                                   port=port,
                                   db=0,
                                   password=password)
    yield connection


# TODO: use connection.pubsub to get a new array for each new scene sent to the
# queue
def read_from_redis(key):
    with gol_connection() as connection:
        dimension = connection.hget(key, 'dimensions').decode('utf-8')
        message = connection.hget(key, 'messages')  # nothing returned from this yet.

        x, y = tuple(int(num) for num in dimension.split(','))
        array = numpy.fromstring(message, dtype='<i4').reshape((x, y), order='F')
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
    from matplotlib import pyplot
    with gol_connection() as connection:
        if connection.exists('A'):
            loaded_array = numpy.fromstring(connection.brpop('A'), dtype='<i4')
            array = loaded_array.reshape((100, 100))
            pyplot.imshow(array)
            pyplot.savefig('scene.png')
        else:
            print('No key `A`.')
