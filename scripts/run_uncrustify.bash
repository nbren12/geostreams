#!/usr/bin/env bash

# Run uncrustify on all geostreams source files

files=`find ../src -name '*.c' -o -name '*.h'`
uncrustify -c uncrustify.cfg -l C --replace --no-backup $files
