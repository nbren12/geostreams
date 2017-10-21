DATAURL = https://www.dropbox.com/s/71pb93feesvz772/columbia_example.tar.gz?dl=0#


# download and process data
example: columbia_example.tar.gz
	tar  --strip-components=6 -xzf columbia_example.tar.gz
	sed  -i.bak 's/read_LUT = true/read_LUT = false/' ./example/icar_options.nml

columbia_example.tar.gz:
	wget -O $@ $(DATAURL)

