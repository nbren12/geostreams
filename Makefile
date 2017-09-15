all:
	make -C src
	make -C game_of_life all
	make -C test
DOCKER = c85726db31a0

run:
	docker run --tty -i -v $(shell pwd):/app  $(DOCKER)  /bin/bash
