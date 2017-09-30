'''stream game of life server

run with

bokeh serve --log-level=debug --show --address=$BOKEH_URL --port=$BOKEH_PORT \
    --allow-websocket-origin="*" geoflix.py

'''

import os
import numpy as np

import redis

from bokeh.plotting import figure, ColumnDataSource
from bokeh.io import curdoc
from bokeh.layouts import gridplot

from collections import deque

from streamz import Stream
from geostreams.client import redis_connection, read_from_redis
from threading import Thread

current = 0

DEFAULT_SHAPE = (200, 200)



frames = deque(maxlen=100)

# Python interface to redis server
r = redis_connection()

# pubsub
p = r.pubsub()
p.subscribe("game_of_life")

class MyThread(Thread):
    def run(self):
        print("Starting thread")
        for x in p.listen():
            if x['type'] == 'message':
                arr = read_from_redis(r, x['data'])
                frames.append(arr)

thread = MyThread()
thread.start()

# get data function
def get():
    if len(frames) > 0:
        return frames.popleft()
    else:
        return None


def make_document(doc):
    shape = (200, 200)
    img = np.zeros(shape)
    source2d = ColumnDataSource(data=dict(img=[img]))
    source1d = ColumnDataSource(data=dict(time=[], live=[]))

    def update():
        global current

        da = get()
        if da is None:
            da = np.zeros(shape)

        current += 1

        s1, s2 = slice(None), slice(None)
        index = [0, s1, s2]
        new_data = da.flatten()
        source2d.patch({'img': [(index, new_data)]})

        live = new_data.sum()
        dead = new_data.size - live
        # print(current, live, dead)
        source1d.stream({'time': [current], 'live': [live / dead * 100.]})

    p2d = figure(plot_width=500, plot_height=500,
                 x_range=(0, shape[0]),
                 y_range=(0, shape[1]),
                 title="Streaming Conway's Game of Life")
    p2d.image(image='img', x=0, y=0, dw=shape[0], dh=shape[1], source=source2d)

    p1d = figure(plot_width=500, plot_height=500,
                 title="Population")
    p1d.line(x='time', y='live', alpha=0.6, line_width=4, color="black",
             source=source1d)
    p1d.xaxis.axis_label = 'Time since begining'
    p1d.yaxis.axis_label = '% Alive'

    doc.add_periodic_callback(update, 100)
    doc.title = "Streaming Conway's Game of Life"
    doc.add_root(gridplot([[p2d, p1d]]))


make_document(curdoc())
