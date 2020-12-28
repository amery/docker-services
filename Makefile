DOCKER=docker

ifneq ($(FORCE),)
DOCKER_BUILD_OPT=--rm --pull --no-cache
else
DOCKER_BUILD_OPT=--rm
endif

B=$(CURDIR)

# scripts
#
GET_FILES_SH = $(CURDIR)/scripts/get_files.sh
GET_VARS_SH = $(CURDIR)/scripts/get_vars.sh

GEN_RULES_MK_SH = $(CURDIR)/scripts/gen_rules_mk.sh
GEN_IMAGES_MK_SH = $(CURDIR)/scripts/gen_images_mk.sh
CONFIG_MK_SH = $(CURDIR)/scripts/config_mk.sh

# generated outputs
#
FILES = $(shell $(GET_FILES_SH) Dockerfile)
TEMPLATES = $(addsuffix .in, $(FILES))
IMAGE_MK_VARS = $(shell $(GET_VARS_SH) $(TEMPLATES))

RULES_MK = rules.mk
CONFIG_MK = config.mk
IMAGES_MK = images.mk
IMAGE_DIRS = .images.mk

.PHONY: all clean images push

all: images

clean:
	rm -f $(B)/.docker-* $(IMAGES_MK) *~

.PHONY: FORCE
FORCE:

$(RULES_MK): $(GEN_RULES_MK_SH) $(TEMPLATES) Makefile
	$< $(IMAGE_MK_VARS) > $@~
	mv $@~ $@

$(CONFIG_MK): $(CONFIG_MK_SH) $(TEMPLATES) Makefile
	$< $@ $(IMAGE_MK_VARS)
	touch $@

$(IMAGES_MK): $(GEN_IMAGES_MK_SH) $(IMAGE_DIRS) Makefile
	xargs -r $< < $(IMAGE_DIRS) > $@~
	mv $@~ $@

$(IMAGE_DIRS): FORCE
	@find * -name Dockerfile -o -name Dockerfile.in | \
		sed -e 's|/[^/]\+$$||' | sort -uV > $@~
	@if ! cmp -s $@~ $@; then mv $@~ $@; else rm $@~; fi

include $(RULES_MK)
include $(CONFIG_MK)
include $(IMAGES_MK)

images: $(IMAGES)
push: $(PUSHERS)

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
