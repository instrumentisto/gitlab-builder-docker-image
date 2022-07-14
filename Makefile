###############################
# Common defaults/definitions #
###############################

comma := ,

# Checks two given strings for equality.
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)




######################
# Project parameters #
######################

IMAGE_VER ?= $(strip \
	$(shell grep 'ARG image_ver=' Dockerfile | cut -d '=' -f2))
DOCKER_VER ?= $(strip \
	$(shell grep 'ARG docker_ver=' Dockerfile | cut -d '=' -f2))
DOCKER_COMPOSE_VER ?= $(strip \
	$(shell grep 'ARG docker_compose_ver=' Dockerfile | cut -d '=' -f2))
KUBECTL_VER ?= $(strip \
	$(shell grep 'ARG kubectl_ver=' Dockerfile | cut -d '=' -f2))
HELM_VER ?= $(strip \
	$(shell grep 'ARG helm_ver=' Dockerfile | cut -d '=' -f2))
REG_VER ?= $(strip \
	$(shell grep 'ARG reg_ver=' Dockerfile | cut -d '=' -f2))
GITLAB_RELEASE_CLI_VER ?= $(strip \
	$(shell grep 'ARG gitlab_release_cli_ver=' Dockerfile | head -1 \
	                                                      | cut -d '=' -f2))

NAME := gitlab-builder
OWNER := $(or $(GITHUB_REPOSITORY_OWNER),instrumentisto)
NAMESPACES := $(OWNER) \
              ghcr.io/$(OWNER) \
              quay.io/$(OWNER)
TAGS ?= $(IMAGE_VER)-docker$(DOCKER_VER)-compose$(DOCKER_COMPOSE_VER)-kubectl$(KUBECTL_VER)-helm$(HELM_VER)-reg$(REG_VER)-releasecli$(GITLAB_RELEASE_CLI_VER) \
        $(IMAGE_VER) \
        $(strip $(shell echo $(IMAGE_VER) | cut -d '.' -f1,2)) \
        latest
VERSION ?= $(word 1,$(subst $(comma), ,$(TAGS)))




###########
# Aliases #
###########

image: docker.image

push: docker.push

release: git.release

tags: docker.tags

test: test.docker




###################
# Docker commands #
###################

docker-namespaces = $(strip $(if $(call eq,$(namespaces),),\
                            $(NAMESPACES),$(subst $(comma), ,$(namespaces))))
docker-tags = $(strip $(if $(call eq,$(tags),),\
                      $(TAGS),$(subst $(comma), ,$(tags))))


# Build Docker image with the given tag.
#
# Usage:
#	make docker.image [tag=($(VERSION)|<docker-tag>)]] [no-cache=(no|yes)]
#	                  [IMAGE_VER=<image-version>]
#	                  [DOCKER_VER=<docker-version>]
#	                  [DOCKER_COMPOSE_VER=<docker-compose-version>]
#	                  [KUBECTL_VER=<kubectl-version>]
#	                  [HELM_VER=<helm-version>]
#	                  [REG_VER=<reg-version>]
#	                  [GITLAB_RELEASE_CLI_VER=<gitlab-release-cli-version>]

github_url := $(strip $(or $(GITHUB_SERVER_URL),https://github.com))
github_repo := $(strip $(or $(GITHUB_REPOSITORY),$(OWNER)/$(NAME)-docker-image))

docker.image:
	docker build --network=host --force-rm \
		$(if $(call eq,$(no-cache),yes),--no-cache --pull,) \
		--build-arg image_ver=$(IMAGE_VER) \
		--build-arg docker_ver=$(DOCKER_VER) \
		--build-arg docker_compose_ver=$(DOCKER_COMPOSE_VER) \
		--build-arg kubectl_ver=$(KUBECTL_VER) \
		--build-arg helm_ver=$(HELM_VER) \
		--build-arg reg_ver=$(REG_VER) \
		--build-arg gitlab_release_cli_ver=$(GITLAB_RELEASE_CLI_VER) \
		--label org.opencontainers.image.source=$(github_url)/$(github_repo) \
		--label org.opencontainers.image.revision=$(strip \
			$(shell git show --pretty=format:%H --no-patch)) \
		--label org.opencontainers.image.version=$(strip \
			$(shell git describe --tags --dirty)) \
		-t $(OWNER)/$(NAME):$(if $(call eq,$(tag),),$(VERSION),$(tag)) ./


# Manually push Docker images to container registries.
#
# Usage:
#	make docker.push [tags=($(TAGS)|<docker-tag-1>[,<docker-tag-2>...])]
#	                 [namespaces=($(NAMESPACES)|<prefix-1>[,<prefix-2>...])]

docker.push:
	$(foreach tag,$(subst $(comma), ,$(docker-tags)),\
		$(foreach namespace,$(subst $(comma), ,$(docker-namespaces)),\
			$(call docker.push.do,$(namespace),$(tag))))
define docker.push.do
	$(eval repo := $(strip $(1)))
	$(eval tag := $(strip $(2)))
	docker push $(repo)/$(NAME):$(tag)
endef


# Tag Docker image with the given tags.
#
# Usage:
#	make docker.tags [of=($(VERSION)|<docker-tag>)]
#	                 [tags=($(TAGS)|<docker-tag-1>[,<docker-tag-2>...])]
#	                 [namespaces=($(NAMESPACES)|<prefix-1>[,<prefix-2>...])]

docker-tags-of = $(if $(call eq,$(of),),$(VERSION),$(of))

docker.tags:
	$(foreach tag,$(subst $(comma), ,$(docker-tags)),\
		$(foreach namespace,$(subst $(comma), ,$(docker-namespaces)),\
			$(call docker.tags.do,$(docker-tags-of),$(namespace),$(tag))))
define docker.tags.do
	$(eval from := $(strip $(1)))
	$(eval repo := $(strip $(2)))
	$(eval to := $(strip $(3)))
	docker tag $(OWNER)/$(NAME):$(from) $(repo)/$(NAME):$(to)
endef


docker.test: test.docker




####################
# Testing commands #
####################

# Run Bats tests for Docker image.
#
# Documentation of Bats:
#	https://github.com/bats-core/bats-core
#
# Usage:
#	make test.docker [tag=($(VERSION)|<tag>)]

test.docker:
ifeq ($(wildcard node_modules/.bin/bats),)
	@make npm.install
endif
	IMAGE=$(OWNER)/$(NAME):$(if $(call eq,$(tag),),$(VERSION),$(tag)) \
	node_modules/.bin/bats \
		--timing $(if $(call eq,$(CI),),--pretty,--formatter tap) \
		tests/main.bats




################
# NPM commands #
################

# Resolve project NPM dependencies.
#
# Usage:
#	make npm.install [dockerized=(no|yes)]

npm.install:
ifeq ($(dockerized),yes)
	docker run --rm --network=host -v "$(PWD)":/app/ -w /app/ \
		node:$(NODE_VER) \
			make npm.install dockerized=no
else
	npm install
endif




################
# Git commands #
################

# Release project version (apply version tag and push).
#
# Usage:
#	make git.release [ver=($(VERSION)|<proj-ver>)]

git-release-tag = $(strip $(if $(call eq,$(ver),),$(VERSION),$(ver)))

git.release:
ifeq ($(shell git rev-parse $(git-release-tag) >/dev/null 2>&1 && echo "ok"),ok)
	$(error "Git tag $(git-release-tag) already exists")
endif
	git tag $(git-release-tag) main
	git push origin refs/tags/$(git-release-tag)




##################
# .PHONY section #
##################

.PHONY: image push release tags test \
        docker.image docker.push docker.tags docker.test \
        git.release \
        npm.install \
        test.docker
