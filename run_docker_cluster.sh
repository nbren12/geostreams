#!/bin/bash -e
# build docker containers
pushd scripts
docker build . -t jdouglass/ghw2017_gameoflife_bokeh
popd

docker build . -t jdouglass/ghw2017_gameoflife

REDIS_CONTAINER="`docker run --name=gameoflife-redis -d --rm redis`"

REDIS_URL=`docker inspect $REDIS_CONTAINER | egrep '\"IPAddress\"' | egrep '([0-9]{1,3}\.){3}[0-9]{1,3}' -o | uniq`

LIFE_CONTAINER=`docker run -d -eREDIS_PORT=6379 -eREDIS_URL=$REDIS_URL --link gameoflife-redis:redis -h gameoflife-redis -p 6379 --rm jdouglass/ghw2017_gameoflife`

docker run -ti -p 8889:8889 -eREDIS_PORT=6379 -eREDIS_URL=$REDIS_URL --link gameoflife-redis:redis -h gameoflife-redis -p 6379 --rm jdouglass/ghw2017_gameoflife_bokeh

# once the bokeh container stops, stop the redis and life containers.
echo "Stopping and cleaning up containers"
docker stop $REDIS_CONTAINER $LIFE_CONTAINER
