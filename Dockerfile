FROM debian:stretch

RUN apt-get update && apt-get -y install gfortran mpich gcc make libhiredis-dev libhiredis0.13

RUN mkdir /gameoflife
ADD Makefile /gameoflife/Makefile
ADD game_of_life /gameoflife/game_of_life
ADD src /gameoflife/src
ADD test /gameoflife/test

RUN cd /gameoflife && make

CMD cd /gameoflife/game_of_life && /bin/bash -c "echo 1 | ./game_of_life"


