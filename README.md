GitLab Builder Docker image
===========================

[![GitHub release](https://img.shields.io/github/release/instrumentisto/gitlab-builder-docker-image.svg)](https://hub.docker.com/r/instrumentisto/gitlab-builder/tags) [![Build Status](https://travis-ci.org/instrumentisto/gitlab-builder-docker-image.svg?branch=master)](https://travis-ci.org/instrumentisto/gitlab-builder-docker-image) [![Docker Pulls](https://img.shields.io/docker/pulls/instrumentisto/gitlab-builder.svg)](https://hub.docker.com/r/instrumentisto/gitlab-builder) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/instrumentisto/gitlab-builder-docker-image/blob/master/LICENSE.md)

Docker image with minimal toolchain required by GitLab Runner to do builds and deployments of containerized applications.




## Overview

This image is intended to be [used by GitLab Runner][1] as general purpose environment for __any__ CI jobs in GitLab CI pipelines.

The idea is to automate any build steps with `Makefile`, and implement them via running commands in Docker containers. This makes build to be environment independent. As the result, build environment requires to have only a minimal set of general purpose tools: `bash`, `git`, `make`, `docker`, `docker-compose`.





[1]: https://docs.gitlab.com/ce/ci/docker/using_docker_images.html
