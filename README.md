# Geostreams
Streaming data from fortran climate/weather models.

## Goals

Provide a *convenient* interface for streaming numerical arrays from existing open source fortran/c numerical models to python. 

## Why

Numerical models of physical systems essentially produces streams of petabytes of data, but in typical applications only a small portion of this data can be written to disk. For simulations with both high spatial and temporal resolution, even storing a single snapshot of the model state is very expensive, and this situation is becoming increasingly relevant with the use of global atmospheric and oceanic models which are run up to 10km resolution. Most of the development in data analysis is focused on building expressive tools for analyzing very large on disk datasets, usually in the form of netCDF files. In particular, xarray, dask, and the pangeo project are making great strides in this direction. However, once the datasets are too large to practically read/write from disk it will be cheaper to just re-run any simulation and perform the analysis on the fly, and convenient tools for doing this are sorely needed.

## How

The three main issues we have identified in this project are

1. Serialization of fortran/C arrays
2. Communication of the serialized data.
3. Parallelization and distribution of this data.

This project will likely require 1) a sample fortran code which produces large amounts of data, 2) a server program which judiciously chooses when and how to communicate portions of the model state, and 3) clients which communicate with this server.
