import os
import uuid
from subprocess import Popen

import numpy.testing

from geostreams import client
import pytest


@pytest.fixture
def exe_dir(request):
    rootdir = request.config.rootdir
    return os.path.join(rootdir, "build", "test")


@pytest.fixture
def redis_np_dict():
    return client.numpy_redis_mapping()


def run_project_exe(exe_name, exe_dir=None):
    """Run exe in ./test directory and raise an error if it doesn't run correctly
    """
    exe = os.path.join(exe_dir, exe_name)
    ret = Popen([exe], env=os.environ).wait()
    if ret != 0:
        raise RuntimeError(f"{exe_name} returned with code {ret}.")


def test_write_to_redis():
    key = str(uuid.uuid4())

    connection = client.redis_connection()
    try:
        array = numpy.tile(numpy.arange(100).reshape((100, 1)), (1, 200))
        client.write_to_redis(connection, key, array)
    finally:
        connection.delete(key)


@pytest.mark.parametrize("exe", ['test_connect', 'test_redis_push',
                                 'test_getuniq'])
def test_exes(exe_dir, exe):
    run_project_exe(exe, exe_dir)


@pytest.mark.parametrize("key", ['A-f4', 'A-f8', 'A-i2', 'A-i4'])
def test_redis_push(exe_dir, key, redis_np_dict):
    run_project_exe('test_redis_push', exe_dir)
    array = redis_np_dict[key]
    x, _ = numpy.mgrid[1:201, 1:101]
    if key[-2] == 'f':
        x = x + .5
    numpy.testing.assert_array_equal(x, array)
