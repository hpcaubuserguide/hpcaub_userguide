# ======================================================================================
SHELL := /bin/bash
ROOT := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: nothing
nothing:

help:
	@echo "no help info"

all:
	cd userdoc && make html
	echo "file://"$(ROOT)"/userdoc/_build/html/index.html"

run:
	python -m http.server 40080 -b 127.0.0.1 --director userdoc/_build/html/

clean:
	rm -fvr \#* *~ *.exe out
	rm -fvr userdoc/_build

help:
	conda activate sphinx-hpcaub-userguide
	. .venv_sphinx8/bin/activate
	make all
# ======================================================================================
