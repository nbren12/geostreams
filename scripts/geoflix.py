'''stream game of life server

run with

bokeh serve --log-level=debug --show --address=$BOKEH_URL --port=$BOKEH_PORT \
    --allow-websocket-origin="*" geoflix.py

'''

import os
import xarray as xr
import numpy as np

import redis

from bokeh.plotting import figure, ColumnDataSource
from bokeh.io import curdoc

current = 0


# Python interface to redis server
r = redis.StrictRedis(host=os.getenv('REDIS_URL'),
                      port=os.getenv('REDIS_PORT'),
                      password=os.getenv('REDIS_PW'), db=0,)


# get data function
def get(key='A', shape=(22, 22)):
    out = r.brpop(key, timeout=5)
    if out is None:
        return out
    key, vals = out
    data = np.fromstring(vals, dtype='<i4').reshape(shape, order='F')
    return xr.DataArray(data,  dims=('x', 'y'), name=key)


def make_document(doc):
    shape = (200, 200)
    img = np.zeros(shape)
    source2d = ColumnDataSource(data=dict(img=[img]))
    dead = img.size
    live = 0
    source1d = ColumnDataSource(data=dict(xs=[0, 0], ys=[dead, live],
                                color=["black", "red"]))

    def update():
        global current
        current += 1

        da = get(shape=(200, 200))
        if da is None:
            return

        s1, s2 = slice(None), slice(None)
        index = [0, s1, s2]
        new_data = da.values.flatten()
        source2d.patch({'img': [(index, new_data)]})

        live = new_data.sum()
        dead = new_data.size - live
        source1d.patch({'ys': [([0, current], [dead, live])]})

    p2d = figure(plot_width=500, plot_height=500,
                 x_range=(0, shape[0]),
                 y_range=(0, shape[1]),
                 title="Streaming Conway's Game of Life")
    p2d.image(image='img', x=0, y=0, dw=shape[0], dh=shape[1], source=source2d)

    p1d = figure(plot_width=500, plot_height=500,
                 x_range=(0, shape[0]),
                 y_range=(0, shape[1]),
                 title="Populations")
    p1d.multi_line('xs', 'ys', alpha=0.6, line_width=4, color="color",
                   source=source1d)

    doc.add_periodic_callback(update, 1)
    doc.title = "Streaming Conway's Game of Life"
    doc.add_root(p2d)


make_document(curdoc())
