# This Makefile automates possible operations of this project.
#
# Images and description on Docker Hub will be automatically rebuilt on
# pushes to `master` branch of this repo and on updates of parent image.
#
# Note! Docker Hub `post_push` hook must be always up-to-date with default
# values of current Makefile. To update it just use:
#	make post-push-hook
#
# It's still possible to build, tag and push images manually. Just use:
#	make release


comma := ,
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)

DOCKER_VER ?= $(strip \
	$(shell grep 'ARG docker_ver=' Dockerfile | cut -d '=' -f2))
DOCKER_COMPOSE_VER ?= $(strip \
	$(shell grep 'ARG docker_compose_ver=' Dockerfile | cut -d '=' -f2))
KUBECTL_VER ?= $(strip \
	$(shell grep 'ARG kubectl_ver=' Dockerfile | cut -d '=' -f2))
HELM_VER ?= $(strip \
	$(shell grep 'ARG helm_ver=' Dockerfile | cut -d '=' -f2))
HELM2_VER ?= $(strip \
	$(shell grep 'ARG helm2_ver=' Dockerfile | cut -d '=' -f2))
REG_VER ?= $(strip \
	$(shell grep 'ARG reg_ver=' Dockerfile | cut -d '=' -f2))

IMAGE_NAME := instrumentisto/gitlab-builder
TAGS ?= 0.6.0-docker$(DOCKER_VER)-compose$(DOCKER_COMPOSE_VER)-kubectl$(KUBECTL_VER)-helm$(HELM_VER)-helm$(HELM2_VER)-reg$(REG_VER) \
        0.6.0 \
        0.6 \
        latest
VERSION ?= $(word 1,$(subst $(comma), ,$(TAGS)))



# Build Docker image.
#
# Usage:
#	make image [tag=($(VERSION)|<docker-tag>)] [no-cache=(no|yes)]
#	           [DOCKER_VER=<docker-version>]
#	           [DOCKER_COMPOSE_VER=<docker-compose-version>]
#	           [KUBECTL_VER=<kubectl-version>]
#	           [HELM_VER=<helm-version>]
#	           [HELM2_VER=<helm2-version>]
#	           [REG_VER=<reg-version>]

image-tag = $(if $(call eq,$(tag),),$(VERSION),$(tag))

image:
	docker build --network=host --force-rm \
		$(if $(call eq,$(no-cache),yes),--no-cache --pull,) \
		--build-arg docker_ver=$(DOCKER_VER) \
		--build-arg docker_compose_ver=$(DOCKER_COMPOSE_VER) \
		--build-arg kubectl_ver=$(KUBECTL_VER) \
		--build-arg helm_ver=$(HELM_VER) \
		--build-arg helm2_ver=$(HELM2_VER) \
		--build-arg reg_ver=$(REG_VER) \
		-t $(IMAGE_NAME):$(image-tag) .



# Tag Docker image with given tags.
#
# Usage:
#	make tags [for=($(VERSION)|<docker-tag>)]
#	          [tags=($(TAGS)|<docker-tag-1>[,<docker-tag-2>...])]

tags-for = $(if $(call eq,$(for),),$(VERSION),$(for))
tags-tags = $(if $(call eq,$(tags),),$(TAGS),$(tags))

tags:
	$(foreach tag, $(subst $(comma), ,$(tags-tags)),\
		$(call tags.do,$(tags-for),$(tag)))
define tags.do
	$(eval from := $(strip $(1)))
	$(eval to := $(strip $(2)))
	docker tag $(IMAGE_NAME):$(from) $(IMAGE_NAME):$(to)
endef



# Manually push Docker images to Docker Hub.
#
# Usage:
#	make push [tags=($(TAGS)|<docker-tag-1>[,<docker-tag-2>...])]

push-tags = $(if $(call eq,$(tags),),$(TAGS),$(tags))

push:
	$(foreach tag, $(subst $(comma), ,$(push-tags)),\
		$(call push.do, $(tag)))
define push.do
	$(eval tag := $(strip $(1)))
	docker push $(IMAGE_NAME):$(tag)
endef



# Make manual release of Docker images to Docker Hub.
#
# Usage:
#	make release [tag=($(VERSION)|<docker-tag>)] [no-cache=(no|yes)]
#	             [tags=($(TAGS)|<docker-tag-1>[,<docker-tag-2>...])]
#	             [DOCKER_VER=<docker-version>]
#	             [DOCKER_COMPOSE_VER=<docker-compose-version>]
#	             [KUBECTL_VER=<kubectl-version>]
#	             [HELM_VER=<helm-version>]
#	             [HELM2_VER=<helm2-version>]
#	             [REG_VER=<reg-version>]

release:
	@make image tag=$(tag) no-cache=$(no-cache) \
	            DOCKER_VER=$(DOCKER_VER) \
	            DOCKER_COMPOSE_VER=$(DOCKER_COMPOSE_VER) \
	            KUBECTL_VER=$(KUBECTL_VER) \
	            HELM_VER=$(HELM_VER) \
	            REG_VER=$(REG_VER)
	@make tags for=$(tag) tags=$(tags)
	@make push tags=$(tags)



# Create `post_push` Docker Hub hook.
#
# When Docker Hub triggers automated build all the tags defined in `post_push`
# hook will be assigned to built image. It allows to link the same image with
# different tags, and not to build identical image for each tag separately.
# See details:
# http://windsock.io/automated-docker-image-builds-with-multiple-tags
#
# Usage:
#	make post-push-hook [tags=($(TAGS)|<docker-tag-1>[,<docker-tag-2>...])]
#	                    [out=(hooks/post_push|<file-path>)]

post-push-hook-tags = $(if $(call eq,$(tags),),$(TAGS),$(tags))

post-push-hook:
	@mkdir -p hooks/
	docker run --rm -v "$(PWD)/post_push.tmpl.php":/post_push.php:ro \
		php:alpine php -f /post_push.php -- \
			--image_tags='$(post-push-hook-tags)' \
		> $(if $(call eq,$(out),),hooks/post_push,$(out))



# Run Bats tests for Docker image.
#
# Documentation of Bats:
#	https://github.com/bats-core/bats-core
#
# Usage:
#	make test [tag=($(VERSION)|<docker-tag>)]

test-tag = $(if $(call eq,$(tag),),$(VERSION),$(tag))

test:
ifeq ($(wildcard node_modules/.bin/bats),)
	@make deps.bats
endif
	IMAGE=$(IMAGE_NAME):$(test-tag) \
	node_modules/.bin/bats test/suite.bats



# Resolve project dependencies for running tests with Yarn.
#
# Usage:
#	make deps.bats

deps.bats:
	docker run --rm --network=host -v "$(PWD)":/app -w /app \
		node:alpine \
			yarn install --non-interactive --no-progress



.PHONY: image tags push release post-push-hook test deps.bats
