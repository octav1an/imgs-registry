#!/bin/sh
set -e

source .env

TAG=$VERSION-$(git rev-parse --short HEAD)
NGINX_IMAGE=$PRIVATE_REGISTRY/nginx:$TAG
REGISTRY_IMAGE=$PRIVATE_REGISTRY/registry:$TAG
# Env vars are interpolated into compose file
export NGINX_IMAGE
export REGISTRY_IMAGE

# Build artifacts
docker build --no-cache -t=$NGINX_IMAGE --platform=$PLATFORM nginx
docker build --no-cache -t=$REGISTRY_IMAGE --platform=$PLATFORM registry

docker image save --output bin/images.tar $NGINX_IMAGE $REGISTRY_IMAGE

mkdir -p bin
# Replace all local absolute paths with relative
docker compose -f docker-compose.yml -f docker-compose.prod.yml config | sed "s|$(pwd)|.|g" > bin/docker-compose.yml

# Archive all the config files necessary for deployment
tar -cf bin/configs.tar --no-xattrs certs -C bin docker-compose.yml

# Clean up
docker rmi $NGINX_IMAGE
docker rmi $REGISTRY_IMAGE
# rm bin/docker-compose.final.yml #TODO: add a clean up script

