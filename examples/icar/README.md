This example will demonstrate using geostreams with a newly developed idealized
atmospheric model ICAR. It uses a realistic sample forcing example which we can
download from dropbox. This downloading process is automated using make.

Instructions
============

Download extract and patch the test case using
    make

Then run it using 
    ./run.sh

Behind the scenes, this run script runs a docker image for ICAR available on
dockerhub.

Issues
======

ICAR is currently running out of memory in the docker image. I am running it
with 5GB of RAM, but that is not enough, so the process is killed by the OS.
See the output below:

	============================================================
	 |                                                          |
	 |  The Intermediate Complexity Atmospheric Research Model  |
	 |                          (ICAR)                          |
	 |                                                          |
	 |   Developed at NCAR:                                     |
	 |     The National Center for Atmospheric Research         |
	 |     NCAR is sponsored by the National Science Foundation |
	 |                                                          |
	 |   Version: 0.9.5                                         |
	 |                                                          |
	 ============================================================

	 Initializing Options
	 Using options file = icar_options.nml
	   Model version: 0.9.5
	   Boundary conditions files to be used:
		   forcing/icar_cesm001_input_001_20TR_1990-01-01_00:00:00

	 Initializing Domain
	 Missing explicit soil T, using deep soil T for all depths

	 Initializing Boundaries
	 Missing explicit soil T, using deep soil T for all depths
	   Setting up domain geographic Look Up Tables
	   Setting up vertical interpolation Look Up Tables


	Finished basic initialization
	---------------------------------------
	  1 This example will demonstrate using geostreams with a newly developed idealized

	 Initializing Boundary conditions
	 Initializing linear winds
	   Generating a spatially variable linear perturbation look up table
	 Percent Completed:
	Killed
