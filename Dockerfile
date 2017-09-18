FROM debian:stretch

RUN apt-get update && apt-get -y install gfortran mpich gcc make libhiredis-dev libhiredis0.13
RUN apt-get install -y cmake

#RUN mkdir /gameoflife
#ADD Makefile /gameoflife/Makefile
#ADD game_of_life /gameoflife/game_of_life
#ADD src /gameoflife/src
#ADD test /gameoflife/test

CMD cd /gameoflife/ && make build && \
    /bin/bash -c "echo 3 | ./game_of_life"


