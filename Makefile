DOCKER=docker

ifneq ($(FORCE),)
DOCKER_BUILD_OPT=--rm --pull --no-cache
else
DOCKER_BUILD_OPT=--rm
endif

PREFIX=$(shell id -urn)/
B=$(CURDIR)

.PHONY: all build-images clean

all: build-images

images.mk: scripts/gen_images_mk.sh Makefile
	$^ > $@~
	mv $@~ $@

clean:
	rm -f $(B)/.docker-* images.mk *~

include images.mk

build-images: $(IMAGES)
