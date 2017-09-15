redis_container="`docker run --name=gameoflife-redis -d --rm redis`"

REDIS_URL=`docker inspect $redis_container | egrep '\"IPAddress\"' | egrep '([0-9]{1,3}\.){3}[0-9]{1,3}' -o | uniq`

docker run -ti -eREDIS_PORT=6379 -eREDIS_URL=$REDIS_URL --link gameoflife-redis:redis -h gameoflife-redis -p 6379 --rm jdouglass/ghw2017_gameoflife
