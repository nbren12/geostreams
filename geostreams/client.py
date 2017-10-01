import os
import redis
import numpy


def redis_connection():

    url = os.environ.get('REDIS_URL', "127.0.0.1")
    port = os.environ.get('REDIS_PORT', "6379")
    password = os.environ.get('REDIS_PW', None)

    print(f'Connecting to redis server at {url}:{port}')
    connection = redis.StrictRedis(host=url,
                                   port=port,
                                   db=0,
                                   password=password)
    return connection


def read_from_redis(connection, key):
    dimension = connection.hget(key, 'dimensions').decode('utf-8')
    message = connection.hget(key, 'messages')
    dtype = connection.hget(key, 'dtype')

    # this is in here for historical reasons
    if dtype is None:
        dtype = 'i4'

    x, y = tuple(int(num) for num in dimension.split(','))
    array = numpy.fromstring(message, dtype=dtype)
    return array.reshape((x, y), order='F')


def write_to_redis(connection, key, array):
    data = {
        'dimension': "%s,%s" % array.shape,
        'message': array.tostring('F')  # fortran order
    }
    connection.lpush(key, data)


# Read from the Game Of Life key/value pair.
def read_gol():
    from matplotlib import pyplot
    with resid_connection() as connection:
        if connection.exists('A'):
            loaded_array = numpy.fromstring(connection.brpop('A'), dtype='<i4')
            array = loaded_array.reshape((100, 100))
            pyplot.imshow(array)
            pyplot.savefig('scene.png')
        else:
            print('No key `A`.')
