FROM ubuntu
MAINTAINER Noah Brenowitz

RUN apt-get update  && apt-get -y upgrade 
#RUN apt-get install -y build-essential
RUN apt-get install -y gfortran mpich gcc-5 make

WORKDIR /root

ADD game_of_life_mpi.f90  /root/game_of_life_mpi.f90
ADD Makefile /root/Makefile
ADD fort.11 /root/fort.11

# compile code
RUN make game_of_life_mpi

CMD ["mpiexec", "-n", "4", "/root/game_of_life_mpi"]
