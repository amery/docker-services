DOCKER=docker

ifneq ($(FORCE),)
DOCKER_BUILD_OPT=--rm --pull --no-cache
else
DOCKER_BUILD_OPT=--rm
endif

B=$(CURDIR)

# scripts
#
GET_VARS_SH = $(CURDIR)/scripts/get_vars.sh

GEN_RULES_MK_SH = $(CURDIR)/scripts/gen_rules_mk.sh
GEN_IMAGES_MK_SH = $(CURDIR)/scripts/gen_images_mk.sh
CONFIG_MK_SH = $(CURDIR)/scripts/config_mk.sh

# generated outputs
#
TEMPLATES = $(shell find */ -name Dockerfile.in | sort -V)
IMAGE_MK_VARS = $(shell $(GET_VARS_SH) $(TEMPLATES))

RULES_MK = rules.mk
CONFIG_MK = config.mk
IMAGES_MK = images.mk
IMAGE_DIRS = .images.mk

FILES = $(RULES_MK) $(IMAGES_MK) $(IMAGE_DIRS)

.PHONY: all clean images push

all: images

clean:
	rm -f $(B)/.docker-* $(FILES) *~

.PHONY: FORCE
FORCE:

.PHONY: files
files: $(FILES)

$(RULES_MK): $(GEN_RULES_MK_SH) $(TEMPLATES) Makefile
	@$< $(IMAGE_MK_VARS) > $@~
	@if ! diff -u $@ $@~; then mv $@~ $@; else rm $@~; fi 2> /dev/null

$(CONFIG_MK): $(CONFIG_MK_SH) $(TEMPLATES) Makefile
	@$< $@ $(IMAGE_MK_VARS)
	@touch $@

$(IMAGES_MK): $(GEN_IMAGES_MK_SH) $(IMAGE_DIRS) Makefile
	@xargs -r $< < $(IMAGE_DIRS) > $@~
	@if ! diff -u $@ $@~; then mv $@~ $@; else rm $@~; fi 2> /dev/null

$(IMAGE_DIRS): FORCE
	@find */ -name Dockerfile -o -name Dockerfile.in | xargs -r dirname | sort -uV > $@~
	@if ! diff -u $@ $@~; then mv $@~ $@; else rm $@~; fi 2> /dev/null

include $(RULES_MK)
include $(CONFIG_MK)
include $(IMAGES_MK)

images: $(IMAGES)
push: $(PUSHERS)

$(SENTINELS):
	$(DOCKER) build $(DOCKER_BUILD_OPT) -t $(PREFIX)$(NAME):$(TAG) $(DIR)/
	@mkdir -p $(@D)
	@echo $(PREFIX)$(NAME):$(TAG) > $@~
	@if [ -x $(DIR)/get_version.sh ]; then \
		for V in $$($(DIR)/get_version.sh $(PREFIX)$(NAME):$(TAG)); do \
			$(DOCKER) tag $(PREFIX)$(NAME):$(TAG) $(PREFIX)$(NAME):$$V; \
			echo $$V >> $@~; \
		done; \
	fi
	@mv $@~ $@

$(PUSHERS):
	@xargs -rt $(DOCKER) push < $<
