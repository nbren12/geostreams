FROM continuumio/miniconda

ADD environment.yml environment.yml
RUN conda env create environment.yml


#ADD geoflix.py /app/geoflix.py
WORKDIR /app
CMD /bin/bash -c "source activate geostreams && python setup.py develop &&\
                  bokeh serve --log-level=debug --port=8889 --allow-websocket-origin="*" scripts/geoflix.py"
