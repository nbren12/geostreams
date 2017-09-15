all:
	make -C src
	make -C game_of_life all
	make -C test test_send
DOCKER = c85726db31a0

run:
	docker run --tty -i -v $(shell pwd):/app  $(DOCKER)  /bin/bash
