#!/usr/bin/env bash

PROJECT_NAME=$(basename $PWD)
DOCKER_IMAGE="local/infra_builder:$PROJECT_NAME"

prep() {
  if [[ ! -d "$PWD/.home" ]]; then
    mkdir "$PWD/.home"
    fi
}

function build() {
  pushd ./tools || exit
  docker build -t "$DOCKER_IMAGE" .
  popd || exit
}

function run_docker() {
  if [ -z "$*" ]; then
    CMD="bash"
  else
    CMD="$*"
  fi
  docker run --rm -it --user "$(id -u):$(id -g)" --hostname "$PROJECT_NAME" -v "$PWD:/mnt" -p 8000-9000:8000-9000 "$DOCKER_IMAGE" "$CMD"
}

prep && build && run_docker "$*"
