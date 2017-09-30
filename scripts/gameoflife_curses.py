'''stream game of life server

run with

bokeh serve --log-level=debug --show --address=$BOKEH_URL --port=$BOKEH_PORT \
    --allow-websocket-origin="*" geoflix.py

'''

import os
from functools import partial
import numpy as np

import redis


from streamz import Stream
from geostreams.client import redis_connection, read_from_redis
from threading import Thread


# Python interface to redis server
r = redis_connection()



# pubsub
p = r.pubsub()
p.subscribe("game_of_life")

# make stream
source = Stream()
s = source.filter(lambda x: x['type'] == 'message')\
          .map(lambda msg: msg['data'])\
          .map(lambda key: read_from_redis(r, key))

class MyThread(Thread):
    def run(self):
        for key in p.listen():
            source.emit(key)

thread = MyThread()
import time
# curses
import curses

win = curses.initscr()
win.addstr(0, 0, "hello")
n, m = win.getmaxyx()


def print_gol(data):
    from io import StringIO
    data = data[:n-1,:m-1]
    win.clear()
    for i, row in enumerate(data):
        for j, col in enumerate(row):
            if col == 0:
                ch = " "
            else:
                ch = "x"
            win.addch(i,j,ch)
    win.refresh()

s.sink(print_gol)
thread.run()

# listener = p.listen()
# key = next(listener)
# key = next(listener)
# from IPython import embed; embed()

