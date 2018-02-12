GitLab Builder Docker image
===========================

[![GitHub release](https://img.shields.io/github/release/instrumentisto/gitlab-builder-docker-image.svg)](https://hub.docker.com/r/instrumentisto/gitlab-builder/tags) [![Build Status](https://travis-ci.org/instrumentisto/gitlab-builder-docker-image.svg?branch=master)](https://travis-ci.org/instrumentisto/gitlab-builder-docker-image) [![Docker Pulls](https://img.shields.io/docker/pulls/instrumentisto/gitlab-builder.svg)](https://hub.docker.com/r/instrumentisto/gitlab-builder)




## What is GitLab Builder Docker image?

Docker image with minimal toolchain required by GitLab Runner to do builds and deployments of containerized applications.

This image is intended to be [used by GitLab Runner][1] as general purpose environment for **any** CI jobs in GitLab CI pipelines.

The idea is:
1. To build any project artifacts with `docker run` and `docker build` commands. So, even build environment of artifacts is fixed and controllable.
2. Run any tests and checks with `docker run` and/or in `docker-compose` environment.
3. Push project's Docker images with `docker push` to Docker Registry.
4. Deploy project to staging/production environments with `helm` (and/or `kubectl`).
5. Commands of the described above steps may be shortened with `Makefile`.

This approach allows to fix and use the same environment for any project's operations both on CI and in local development. And the required toolset **for any project** is only: `bash`, `git`, `make`, `curl`, `docker`, `docker-compose`, `kubectl`, `helm`.

![Logo](https://cdn-images-1.medium.com/max/646/1*ZTVAANqTcZaLEeJXN0Y84g.png)




## License

This Docker image is licensed under [MIT license][91].




## Issues

We can't notice comments in the DockerHub so don't use them for reporting issue or asking question.

If you have any problems with or questions about this image, please contact us through a [GitHub issue][90].





[1]: https://docs.gitlab.com/ce/ci/docker/using_docker_images.html
[90]: https://github.com/instrumentisto/gitlab-builder-docker-image/issues
[91]: https://github.com/instrumentisto/gitlab-builder-docker-image/blob/master/LICENSE.md
