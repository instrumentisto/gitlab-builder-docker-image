FROM gitlab/gitlab-runner:alpine

MAINTAINER Instrumentisto Team <developer@instrumentisto.com>


RUN apk add --update --no-cache \
            tini \
            make \
            docker \
 && rm -rf /var/cache/apk/*


# Not existing `dumb-init` because of:
# https://github.com/Yelp/dumb-init/issues/51
# May be removed after `gitlab/gitlab-runner` image updates `dumb-init`
# to version >= 1.2.0. See:
# https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/dockerfiles/alpine/Dockerfile
ENTRYPOINT ["/sbin/tini", "--"]
