#!/bin/sh

set -e

main() {
  if [ -n "$1" ]; then
    build "$1"
  else
    TAGS="$(find . -name "*.Dockerfile")"

    for TAG in $TAGS; do
      TAG="$(echo $TAG | sed -e "s/\\.\\///" | sed -e "s/\\.Dockerfile//")"

      build "$TAG"
    done
  fi
}

build() {
  TAG=$1

  docker build -f "$TAG.Dockerfile" -t "ntrrg/nginx:$TAG" .
  docker run --rm "ntrrg/nginx:$TAG" nginx -t
}

main $@
