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


@test "contains docker" {
  run docker run --rm $IMAGE which docker
  [ "$status" -eq 0 ]
}

@test "docker runs ok" {
  run docker run --rm $IMAGE docker --help
  [ "$status" -eq 0 ]
}


@test "contains gitlab-runner" {
  run docker run --rm $IMAGE which gitlab-runner
  [ "$status" -eq 0 ]
}

@test "gitlab-runner runs ok" {
  run docker run --rm $IMAGE gitlab-runner --help
  [ "$status" -eq 0 ]
}
