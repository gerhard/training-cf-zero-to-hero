SHELL := bash# we want bash behaviour in all shell invocations



### VARS ###
#

TOPIC ?= 01-what-is-cf

DOCKER_IMAGE := cf-zero-hero:2019.07.09



### DEPS ###
#

DOCKER := /usr/local/bin/docker
$(DOCKER):
	@brew cask install docker



### TARGETS ###
#
.DEFAULT_GOAL := help

SEPARATOR := ----------------------------------------
.PHONY: help
help:
	@grep -E '^[0-9a-zA-Z_-]+:+.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN { FS = "[:#]" } ; { printf "$(SEPARATOR)\n\033[36m%-12s\033[0m %s\n", $$1, $$4 }' ; \
	echo $(SEPARATOR)

.PHONY: build
build: $(DOCKER) ## b | Build Docker image
	@$(DOCKER) build \
	  --tag $(DOCKER_IMAGE) \
	  $(CURDIR)
.PHONY: b
b: build

.PHONY: preview
preview: $(DOCKER) ## p | Preview slides locally
	@$(DOCKER) run --interactive --tty \
	  --volume $(CURDIR)/01-what-is-cf:/slides/01-what-is-cf \
	  --volume $(CURDIR)/02-interact-with-cf:/slides/02-interact-with-cf \
	  --volume $(CURDIR)/03-first-app:/slides/03-first-app \
	  --volume $(CURDIR)/04-buildpacks:/slides/04-buildpacks \
	  --volume $(CURDIR)/05-resilience:/slides/05-resilience \
	  --volume $(CURDIR)/06-debugging:/slides/06-debugging \
	  --volume $(CURDIR)/07-shared-state:/slides/07-shared-state \
	  --volume $(CURDIR)/08-domain-routes:/slides/08-domain-routes \
	  --publish 1948:1948 \
	  $(DOCKER_IMAGE)
.PHONY: p
p: preview

.PHONY: static
static: build ## s | Create static slides
	@rm -fr $(CURDIR)_static && \
	$(DOCKER) run --rm \
	  --volume $(CURDIR)/_static:/home/node/slides/_static \
	  $(DOCKER_IMAGE) \
	  reveal-md --static --disable-auto-open
.PHONY: s
s: static
