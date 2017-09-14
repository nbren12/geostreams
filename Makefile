all:
	make -C src
	make -C game_of_life all
	make -C test
