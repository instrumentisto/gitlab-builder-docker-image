GitLab Builder Docker image
===========================

[![Docker Pulls](https://img.shields.io/docker/pulls/instrumentisto/gitlab-builder.svg)](https://hub.docker.com/r/instrumentisto/gitlab-builder)
[![GitHub link](https://img.shields.io/badge/github-link-blue.svg)](https://github.com/instrumentisto/gitlab-builder-docker-image)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/instrumentisto/gitlab-builder-docker-image/blob/master/LICENSE.md)


Docker image with minimal toolchain required by GitLab Runner to do builds.



## Overview

This image is intended to be [used by GitLab Runner][1] as general purpose
environment for __any__ builds.

The idea is to automate any build steps with `Makefile`, and implement them
via running commands in Docker containers. This makes build to be environment
independent. As the result, build environment requires to have only a minimal
set of general purpose tools: `bash`, `git`, `make`, `docker`.

This image contains `git` and GitLab Runner binaries as far as [Kubernetes
executor of GitLab Runner requires them][2].





[1]: https://docs.gitlab.com/ce/ci/docker/using_docker_images.html
[2]: https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/docs/executors/kubernetes.md#workflow
