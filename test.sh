#!/bin/bash
set -e

DIRECTORY="$( cd "$( dirname "$0" )" && pwd )"
TAG=edyan/satisfy:latest
GREEN='\033[0;32m'
NC='\033[0m' # No Color

cd
echo "Building image"
cd ${DIRECTORY}
./build.sh

echo ""
echo -e "${GREEN}Testing image${NC}"

echo -e "${GREEN}Entering tests/${NC}"
cd tests

dgoss run -e GOSS_FILES_STRATEGY=cp ${TAG}
