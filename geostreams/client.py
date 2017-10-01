import os
from collections import Mapping, Iterable
import redis
import numpy
from zict.common import ZictBase

def _nested_decode(tree):
    # TODO
    stack = [tree]
    output = [[]]

    while len(stack) > 0:
        item = stack.pop()
        out  = output.pop()
        if isinstance(item, Mapping):
            out.append()




class Redis(ZictBase):

    def __init__(self, r: redis.StrictRedis):
        "docstring"
        self.redis_connection = r

    def keys(self):
        return self.redis_connection.keys('*')

    __iter__ = keys


    def __len__(self):
        return self.redis_connection.dbsize()

    def __getitem__(self, key):
        key_type = self.redis_connection.type(key).decode("utf-8")
        if key_type == 'string':
            return self.redis_connection.get(key)\
                       .decode("utf-8")
        elif key_type == 'list':
            return [x.decode("utf-8") for x in
                    self.redis_connection.lrange(key, 0, -1)]
        elif key_type == 'hash':
            d =  self.redis_connection.hgetall(key)
            return {k.decode("utf-8"): v.decode("utf-8")
                    for k,v in d.items()}

    def __setitem__(self, key, value):

        del self[key]

        # insert strings as strings
        if isinstance(value, str):
            self.redis_connection.set(key, value)
            return

        # insert dicts as hashes
        if isinstance(value, Mapping):
            for k, v in value.items():
                self.redis_connection.hset(key, k, v)

        elif isinstance(value, Iterable):
            for item in value:
                self.redis_connection.rpush(key, item)



    def __delitem__(self, key):
        self.redis_connection.delete(key)



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
