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

clean:
	rm -fvr \#* *~ *.exe out
	find . -name __pycache__ -exec rm -fvr '{}' \;
# ======================================================================================
