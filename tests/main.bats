#!/usr/bin/env bats


@test "contains bash" {
  run docker run --rm $IMAGE which bash
  [ "$status" -eq 0 ]
}

@test "bash runs ok" {
  run docker run --rm $IMAGE bash -c "printf hi"
  [ "$status" -eq 0 ]
  [ "$output" == "hi" ]
}


@test "contains git" {
  run docker run --rm $IMAGE which git
  [ "$status" -eq 0 ]
}

@test "git runs ok" {
  run docker run --rm $IMAGE git --help
  [ "$status" -eq 0 ]
}


@test "contains make" {
  run docker run --rm $IMAGE which make
  [ "$status" -eq 0 ]
}

@test "make runs ok" {
  run docker run --rm $IMAGE make --help
  [ "$status" -eq 0 ]
}


@test "contains curl" {
  run docker run --rm $IMAGE which curl
  [ "$status" -eq 0 ]
}

@test "curl runs ok" {
  run docker run --rm $IMAGE curl --help
  [ "$status" -eq 0 ]
}


@test "contains rsync" {
  run docker run --rm $IMAGE which rsync
  [ "$status" -eq 0 ]
}

@test "rsync runs ok" {
  run docker run --rm $IMAGE rsync --help
  [ "$status" -eq 0 ]
}


@test "contains docker" {
  run docker run --rm $IMAGE which docker
  [ "$status" -eq 0 ]
}

@test "docker runs ok" {
  run docker run --rm $IMAGE docker --help
  [ "$status" -eq 0 ]
}


@test "contains docker-compose" {
  run docker run --rm $IMAGE which docker-compose
  [ "$status" -eq 0 ]
}

@test "docker-compose runs ok" {
  run docker run --rm $IMAGE docker-compose --help
  [ "$status" -eq 0 ]
}


@test "contains kubectl" {
  run docker run --rm $IMAGE which kubectl
  [ "$status" -eq 0 ]
}

@test "kubectl runs ok" {
  run docker run --rm $IMAGE kubectl --help
  [ "$status" -eq 0 ]
}


@test "contains helm" {
  run docker run --rm $IMAGE which helm
  [ "$status" -eq 0 ]
}

@test "helm runs ok" {
  run docker run --rm $IMAGE helm --help
  [ "$status" -eq 0 ]
}

@test "helm has correct version" {
  run sh -c "grep 'ARG helm_ver=' Dockerfile | cut -d '=' -f2"
  [ "$status" -eq 0 ]
  [ ! "$output" = '' ]
  expected="$output"

  run docker run --rm $IMAGE sh -c "helm version | grep 'Version:' \
                                                 | cut -d ':' -f2 \
                                                 | cut -d '\"' -f2 \
                                                 | cut -d 'v' -f2"
  [ "$status" -eq 0 ]
  [ ! "$output" = '' ]
  actual="$output"

  [ "$actual" = "$expected" ]
}

@test "contains helm-push plugin" {
  run docker run --rm $IMAGE sh -c 'helm plugin list | grep -e "^push\t"'
  [ "$status" -eq 0 ]
}

@test "helm-push plugin runs ok" {
  run docker run --rm $IMAGE helm push --help
  [ "$status" -eq 0 ]
}


@test "contains reg" {
  run docker run --rm $IMAGE which reg
  [ "$status" -eq 0 ]
}

@test "reg runs ok" {
  run docker run --rm $IMAGE reg version
  [ "$status" -eq 0 ]
}

@test "reg has correct version" {
  run sh -c "grep 'ARG reg_ver=' Dockerfile | cut -d '=' -f2"
  [ "$status" -eq 0 ]
  [ ! "$output" = '' ]
  expected="$output"

  run docker run --rm $IMAGE sh -c "reg version | grep ' version     :' \
                                                | cut -d ':' -f2 \
                                                | cut -d 'v' -f2"
  [ "$status" -eq 0 ]
  [ ! "$output" = '' ]
  actual="$output"

  [ "$actual" = "$expected" ]
}


@test "contains release-cli" {
  run docker run --rm $IMAGE which release-cli
  [ "$status" -eq 0 ]
}

@test "release-cli runs ok" {
  run docker run --rm $IMAGE release-cli -v
  [ "$status" -eq 0 ]
}

@test "release-cli has correct version" {
  run sh -c "grep 'ARG gitlab_release_cli_ver=' Dockerfile | head -1 \
                                                           | cut -d '=' -f2"
  [ "$status" -eq 0 ]
  [ ! "$output" = '' ]
  expected="$output"

  run docker run --rm $IMAGE sh -c "release-cli -v | grep ' version ' \
                                                   | cut -d ' ' -f3"
  [ "$status" -eq 0 ]
  [ ! "$output" = '' ]
  actual="$output"

  [ "$actual" = "$expected" ]
}
