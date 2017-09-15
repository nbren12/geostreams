#!/bin/bash -e
#
# Build and run a docker container cluster with three containers, each running a service:
#  * Game of Life (fortran implementation of Conway's game of life that pushes scenes to redis)
#  * Redis server (for communicating scenes from game of life to clients)
#  * Bokeh server (for displaying messages sent through redis)
#
# To run, just call this script.
#
# NOTE: This script will block on the bokeh server.  Control-C to shut it down.
# This script will clean up running containers once the bokeh server quits.
# 
# NOTE: Container state is automatically removed when the containers stop.

# build docker containers
pushd scripts
docker build . -t jdouglass/ghw2017_gameoflife_bokeh
popd
docker build . -t jdouglass/ghw2017_gameoflife

REDIS_CONTAINER="`docker run --name=gameoflife-redis -d --rm redis`"

# Get the IP address of the Redis server within our local docker cluster.
REDIS_URL=`docker inspect $REDIS_CONTAINER | egrep '\"IPAddress\"' | egrep '([0-9]{1,3}\.){3}[0-9]{1,3}' -o | uniq`

LIFE_CONTAINER=`docker run -d -eREDIS_PORT=6379 -eREDIS_URL=$REDIS_URL --link gameoflife-redis:redis -h gameoflife-redis -p 6379 --rm jdouglass/ghw2017_gameoflife`

docker run -ti -p 8889:8889 -eREDIS_PORT=6379 -eREDIS_URL=$REDIS_URL --link gameoflife-redis:redis -h gameoflife-redis -p 6379 --rm jdouglass/ghw2017_gameoflife_bokeh

# once the bokeh container stops, stop the redis and life containers.
echo "Stopping and cleaning up containers"
docker stop $REDIS_CONTAINER $LIFE_CONTAINER
