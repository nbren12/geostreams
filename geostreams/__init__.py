from pathlib import Path


def get_test_exes():
    exe = Path("build/test")

    test_exes = Path(__file__)\
                .absolute()\
                .parent\
                .parent\
                .joinpath(exe)

    return test_exes.as_posix()
