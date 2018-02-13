#!/usr/bin/env bats


@test "post_push hook is up-to-date" {
  run sh -c "cat Makefile | grep 'TAGS ?= ' | cut -d ' ' -f 3"
  [ "$status" -eq 0 ]
  [ ! "$output" = '' ]
  expected="$output"

  run sh -c "cat hooks/post_push | grep 'for tag in' \
                                 | cut -d '{' -f 2 \
                                 | cut -d '}' -f 1"
  [ "$status" -eq 0 ]
  [ ! "$output" = '' ]
  actual="$output"

  [ "$actual" = "$expected" ]
}


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
