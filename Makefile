.PHONY: build_image start_container

all: build_image start_container

build_image:
	docker build -t python-playground .

start_container:
	docker run python-playground
