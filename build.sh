#!/usr/bin/env bash

set -e

#/ build.sh [VERSION] [REPOSITORY]
#/
#/ Builds the image for the Concourse resource, tags it with the provided VERSION
#/ (or :latest if no version is given) and pushes it to
#/ a given repository on Dockerhub or any DTR (or using 'michaellihs' as default repo).
#/
#/ Examples:
#/
#/ ./build.sh latest michaellihs
#/
#/ Options:
#/   --help: Display this help message
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }
expr "$*" : ".*--help" > /dev/null && usage

version=${1:-latest}
repo=${2:-michaellihs}

image_name='rocket-notify-resource'

docker build --no-cache -t ${image_name} .
docker tag ${image_name} ${repo}/${image_name}:${version}
docker push ${repo}/${image_name}:${version}
