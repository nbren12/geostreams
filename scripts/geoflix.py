# This is a Bokeh server app. To function, it must be run using the
# Bokeh server ath the command line:
#
#     bokeh serve --show geoflix.py
#
# Running "python geoflix.py" will NOT work.
import os

import numpy as np
import xarray as xr

import redis

from bokeh.plotting import figure, ColumnDataSource


# Python interface to redis server
r = redis.StrictRedis(host=os.getenv('REDIS_URL'),
                      port=os.getenv('REDIS_PORT'),
                      password=os.getenv('REDIS_PW'),
                      db=0)


# get data function
def get(key='A', shape=(22, 22)):
    key, vals = r.brpop(key)
    data = np.fromstring(vals, dtype='<i4').reshape(shape, order='F')
    return xr.DataArray(data,  dims=('x', 'y'), name=key)


def make_document(doc):
    shape = (200, 200)
    img = np.zeros(shape)
    source = ColumnDataSource(data=dict(img=[img]))

    def update():
        s1, s2 = slice(None), slice(None)
        index = [0, s1, s2]
        da = get(shape=(200, 200))
        new_data = da.values.flatten()
        source.patch({'img': [(index, new_data)]})

    doc.add_periodic_callback(update, 1)
    p2d = figure(plot_width=500, plot_height=500,
                 x_range=(0, shape[0]), y_range=(0, shape[1]),
                 title="Streaming Conway's Game of Life")
    p2d.image(image='img', x=0, y=0, dw=shape[0], dh=shape[1], source=source)
    doc.title = "Streaming Conway's Game of Life"
    doc.add_root(p2d)
