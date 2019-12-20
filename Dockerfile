# https://hub.docker.com/_/alpine/
FROM alpine

ARG docker_ver=19.03.5
ARG docker_compose_ver=1.25.0
ARG kubectl_ver=1.17.0
ARG helm_ver=3.0.2
ARG helm2_ver=2.16.1
ARG reg_ver=0.16.1


# Install Bash, make, cURL, Git.
RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
            tini ca-certificates \
            bash git make curl \
            rsync \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*


# Install Docker CLI.
RUN curl -fL -o /tmp/docker.tar.gz \
         https://download.docker.com/linux/static/edge/x86_64/docker-${docker_ver}.tgz \
 && tar -xvf /tmp/docker.tar.gz -C /tmp/ \
    \
 && chmod +x /tmp/docker/docker \
 && mv /tmp/docker/docker /usr/local/bin/ \
    \
 && mkdir -p /usr/local/share/doc/docker/ \
 && curl -fL -o /usr/local/share/doc/docker/LICENSE \
         https://raw.githubusercontent.com/docker/docker-ce/v${docker_ver}/components/cli/LICENSE \
    \
 && rm -rf /tmp/*


# Install Docker Compose CLI.
RUN curl -fL -o /usr/local/bin/docker-compose \
         https://github.com/docker/compose/releases/download/${docker_compose_ver}/docker-compose-Linux-x86_64 \
 && chmod +x /usr/local/bin/docker-compose \
    \
 && mkdir -p /usr/local/share/doc/docker-compose/ \
 && curl -fL -o /usr/local/share/doc/docker-compose/LICENSE \
         https://raw.githubusercontent.com/docker/compose/${docker_compose_ver}/LICENSE \
    \
 # Download glibc compatible musl library for Docker Compose, see:
 # https://github.com/docker/compose/pull/3856
 && curl -fL -o /etc/apk/keys/sgerrand.rsa.pub \
         https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
 && curl -fL -o /tmp/alpine-pkg-glibc.json \
         https://api.github.com/repos/sgerrand/alpine-pkg-glibc/releases/latest \
 && latestReleaseTag=$(cat /tmp/alpine-pkg-glibc.json \
                       | grep '"tag_name"' | cut -d '"' -f4 | tr -d '\n' ) \
 && curl -fL -o /tmp/glibc-$latestReleaseTag.apk \
         https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$latestReleaseTag/glibc-$latestReleaseTag.apk \
 && apk add --no-cache /tmp/glibc-$latestReleaseTag.apk \
 && ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ \
 && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib/ \
    \
 # Install libgcc_s.so.1 for pthread_cancel to work, see:
 # https://github.com/instrumentisto/gitlab-builder-docker-image/issues/6
 && apk add --update --no-cache libgcc \
 && ln -s /usr/lib/libgcc_s.so.1 /usr/glibc-compat/lib/ \
    \
 && rm -rf /var/cache/apk/* \
           /tmp/*


# Install Kubernetes CLI.
RUN curl -fL -o /usr/local/bin/kubectl \
         https://dl.k8s.io/release/v${kubectl_ver}/bin/linux/amd64/kubectl \
 && chmod +x /usr/local/bin/kubectl


# Install Kubernetes Helm v3.
RUN curl -fL -o /tmp/helm.tar.gz \
         https://get.helm.sh/helm-v${helm_ver}-linux-amd64.tar.gz \
 && tar -xzf /tmp/helm.tar.gz -C /tmp/ \
    \
 && chmod +x /tmp/linux-amd64/helm \
 && mv /tmp/linux-amd64/helm /usr/local/bin/helm3 \
    \
 && mkdir -p /usr/local/share/doc/helm3/ \
 && mv /tmp/linux-amd64/LICENSE /usr/local/share/doc/helm3/ \
    \
 && rm -rf /tmp/*

# Install Kubernetes Helm v2.
RUN curl -fL -o /tmp/helm.tar.gz \
         https://kubernetes-helm.storage.googleapis.com/helm-v${helm2_ver}-linux-amd64.tar.gz \
 && tar -xzf /tmp/helm.tar.gz -C /tmp/ \
    \
 && chmod +x /tmp/linux-amd64/helm \
 && mv /tmp/linux-amd64/helm /usr/local/bin/helm2 \
    \
 && mkdir -p /usr/local/share/doc/helm2/ \
 && mv /tmp/linux-amd64/LICENSE /usr/local/share/doc/helm2/ \
    \
 && rm -rf /tmp/*

# Install Kubernetes Helm wrapper.
RUN echo '#!/bin/sh'                        > /usr/local/bin/helm \
 && echo 'exec "helm$DEFAULT_HELM_VER" $@' >> /usr/local/bin/helm \
 && chmod +x /usr/local/bin/helm

ENV DEFAULT_HELM_VER=3


# Install Docker Registry CLI.
RUN curl -fL -o /usr/local/bin/reg \
         https://github.com/genuinetools/reg/releases/download/v${reg_ver}/reg-linux-amd64 \
 && chmod +x /usr/local/bin/reg \
    \
 && mkdir -p /usr/local/share/doc/reg/ \
 && curl -fL -o /usr/local/share/doc/reg/LICENSE \
          https://github.com/genuinetools/reg/blob/v${reg_ver}/LICENSE


ENTRYPOINT ["/sbin/tini", "--"]
