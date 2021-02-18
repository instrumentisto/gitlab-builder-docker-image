GitLab Builder Docker image
===========================

[![Release](https://img.shields.io/github/v/release/instrumentisto/gitlab-builder-docker-image "Release")](https://github.com/instrumentisto/gitlab-builder-docker-image/releases)
[![CI](https://github.com/instrumentisto/gitlab-builder-docker-image/workflows/CI/badge.svg?branch=master "CI")](https://github.com/instrumentisto/gitlab-builder-docker-image/actions?query=workflow%3ACI+branch%3Amaster)
[![Docker Hub](https://img.shields.io/docker/pulls/instrumentisto/gitlab-builder?label=Docker%20Hub%20pulls "Docker Hub pulls")](https://hub.docker.com/r/instrumentisto/gitlab-builder)

[Docker Hub](https://hub.docker.com/r/instrumentisto/gitlab-builder)
| [GitHub Container Registry](https://github.com/orgs/instrumentisto/packages/container/package/gitlab-builder)
| [Quay.io](https://quay.io/repository/instrumentisto/gitlab-builder)

[Changelog](https://github.com/instrumentisto/gitlab-builder-docker-image/blob/master/CHANGELOG.md)




## Supported tags and respective `Dockerfile` links

- [`0.7.0-docker19.03.15-compose1.28.3-kubectl1.20.3-helm3.5.2-helm2.17.0-reg0.16.1`, `0.7.0`, `0.7`, `latest`][d1]




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




## Helm usage

At the moment the image contains two versions of `helm`:
- `helm2` for [Helm v2](https://v2.helm.sh/docs);
- `helm3` for [Helm v3](https://helm.sh/docs).

They can be used either directly via `helm2`/`helm3` binaries, or via `helm` shim which uses internally `helm3` by default, but may be switched to `helm2` via providing `DEFAULT_HELM_VER=2` env var to a container:
```bash
docker run --rm -e DEFAULT_HELM_VER=2 instrumentisto/gitlab-builder helm version
```




## License

[Docker CLI CE][10] is licensed under [Apache License 2.0][11].  
[Docker Compose CLI][20] is licensed under [Apache License 2.0][21].  
[Kubernetes CLI (`kubectl`)][30] is licensed under [Apache License 2.0][31].  
[Helm][40] is licensed under [Apache License 2.0][41].  
[Docker Registry CLI][50] is licensed under [MIT License][51].

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

The [sources][92] for producing `instrumentisto/gitlab-builder` Docker images are licensed under [Blue Oak Model License 1.0.0][91].




## Issues

We can't notice comments in the [DockerHub] (or other container registries) so don't use them for reporting issue or asking question.

If you have any problems with or questions about this image, please contact us through a [GitHub issue][90].





[DockerHub]: https://hub.docker.com

[1]: https://docs.gitlab.com/ce/ci/docker/using_docker_images.html

[10]: https://github.com/docker/docker-ce/blob/master/components/cli
[11]: https://github.com/docker/docker-ce/blob/master/components/cli/LICENSE

[20]: https://docs.docker.com/compose
[21]: https://github.com/docker/compose/blob/master/LICENSE

[30]: https://kubernetes.io/docs/reference/kubectl/overview
[31]: https://github.com/kubernetes/kubernetes/blob/master/LICENSE

[40]: https://helm.sh
[41]: https://github.com/helm/helm/blob/master/LICENSE

[50]: https://github.com/genuinetools/reg
[51]: https://github.com/genuinetools/reg/blob/master/LICENSE

[90]: https://github.com/instrumentisto/gitlab-builder-docker-image/issues
[91]: https://github.com/instrumentisto/gitlab-builder-docker-image/blob/master/LICENSE.md
[92]: https://github.com/instrumentisto/gitlab-builder-docker-image

[d1]: https://github.com/instrumentisto/gitlab-builder-docker-image/blob/master/Dockerfile
