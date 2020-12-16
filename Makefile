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

.PHONY: all build-images push clean

all: build-images

images.mk: scripts/gen_images_mk.sh Makefile
	$^ > $@~
	mv $@~ $@

clean:
	rm -f $(B)/.docker-* images.mk *~

include images.mk

build-images: $(IMAGES)

push: $(PUSHERS)

%/Dockerfile: %/Dockerfile.in
	@sed -e 's|@@USER@@|$(USER)|g' -e 's|@@MAINTAINER@@|$(MAINTAINER)|g' $^ > $@

$(SENTINELS):
	$(DOCKER) build $(DOCKER_BUILD_OPT) -t $(PREFIX)$(NAME):latest $(DIR)/
	@mkdir -p $(@D)
	@echo $(PREFIX)$(NAME):latest > $@~
	@if [ -x $(DIR)/get_version.sh ]; then \
		for V in $$($(DIR)/get_version.sh $(PREFIX)$(NAME):latest); do \
			$(DOCKER) tag $(PREFIX)$(NAME):latest $(PREFIX)$(NAME):$$V; \
			echo $$V >> $@~; \
		done; \
	fi
	@mv $@~ $@

$(PUSHERS):
	@xargs -rt $(DOCKER) push < $<
