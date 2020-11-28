DOCKER=docker

ifneq ($(FORCE),)
DOCKER_BUILD_OPT=--rm --pull --no-cache
else
DOCKER_BUILD_OPT=--rm
endif

PREFIX=$(shell id -urn)/

.PHONY: all build-images

all: build-images

images.mk: scripts/gen_images_mk.sh Makefile
	$^ > $@~
	mv $@~ $@

include images.mk

build-images: $(IMAGES)
