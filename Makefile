DOCKER=docker

ifneq ($(FORCE),)
DOCKER_BUILD_OPT=--rm --pull --no-cache
else
DOCKER_BUILD_OPT=--rm
endif

USER=$(shell id -urn)
MAINTAINER=$(shell git config user.name) <$(shell git config user.email)>

PREFIX=$(USER)/
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

%/Dockerfile: %/Dockerfile.in
	sed -e 's|@USER@|$(USER)|g' -e 's|@MAINTAINER@|$(MAINTAINER)|g' $^ > $@

$(SENTINELS):
	$(DOCKER) build $(DOCKER_BUILD_OPT) -t $(PREFIX)$(NAME):latest $(DIR)/
	if [ ! -x "$(DIR)/get_version.sh" ]; then \
		: ; \
	elif V=$$($(DIR)/get_version.sh $(PREFIX)$(NAME):latest); then \
		$(DOCKER) tag $(PREFIX)$(NAME):latest $(PREFIX)$(NAME):$$V; \
	fi
	mkdir -p $(@D)
	touch $@
