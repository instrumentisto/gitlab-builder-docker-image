
IMAGE_NAME := instrumentisto/gitlab-builder
VERSION ?= 0.0.1
TAGS ?= latest

no-cache ?= no


comma := ,
empty :=
space := $(empty) $(empty)
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)



no-cache-arg = $(if $(call eq, $(no-cache), yes), --no-cache, $(empty))

image:
	docker build $(no-cache-arg) -t $(IMAGE_NAME):$(VERSION) .



parsed-tags = $(subst $(comma), $(space), $(TAGS))

tags:
	$(foreach tag, $(parsed-tags), \
		docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):$(tag); \
	)



.PHONY: image tags
