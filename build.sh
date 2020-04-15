#!/bin/bash

set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
DOCKERFILE="${DIR}/Dockerfile"
VERSION=${1:-3.2.4}
GREEN='\033[0;32m'
NC='\033[0m' # No Color
TAG=edyan/satisfy:${VERSION}

# Check if git repo is clean
GIT_AVAILABLE=$(which git)
GIT_FILES_TO_COMMIT=$(git status --porcelain)
if [[ "${GIT_AVAILABLE}" != "" && "${GIT_FILES_TO_COMMIT}" != "" ]]; then
    echo "You must make sure Git repo has been commited" >&2
    exit 1
fi

# Build Image
echo "Building ${TAG}"
docker build --tag ${TAG} \
             --cache-from ${TAG} \
             --build-arg BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
             --build-arg VCS_REF="$(git rev-parse --short HEAD)" \
             --build-arg DOCKER_TAG="${TAG}" \
             .

 echo "${TAG} will also be tagged 'latest'"
 docker tag ${TAG} edyan/satisfy:latest

# Nice Message
echo ""
echo ""
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}Build Done${NC}."
    echo ""
    echo "Run for development :"
    echo "  docker run -p 8080:8080 -ti --rm --name satisfy-test-ctn ${TAG}"
    echo "Once Done : "
    echo "  docker stop satisfy-test-ctn"
    echo ""
    echo "To push that version (and other of the same repo):"
    echo "  docker push edyan/satisfy"
fi
