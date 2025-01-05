#!/bin/sh
set -e

source .ci.env

TAG=$VERSION-$(git rev-parse --short HEAD)
NGINX_IMAGE=$PRIVATE_REGISTRY/nginx:$TAG
REGISTRY_IMAGE=$PRIVATE_REGISTRY/registry:$TAG
# Update image names with tags in the .env, this will be used in prod
sed -i.bak -e "s|REGISTRY_IMAGE=.*|REGISTRY_IMAGE=$REGISTRY_IMAGE|" -e "s|^NGINX_IMAGE=.*|NGINX_IMAGE=$NGINX_IMAGE|" .env

# Build artifacts
docker build --no-cache -t=$NGINX_IMAGE --platform=$PLATFORM nginx
docker build --no-cache -t=$REGISTRY_IMAGE --platform=$PLATFORM registry

docker image save --output bin/images.tar $NGINX_IMAGE $REGISTRY_IMAGE

mkdir -p bin
# Replace all local absolute paths with relative
docker compose -f docker-compose.yml -f docker-compose.prod.yml config --no-interpolate --no-normalize --no-path-resolution -o bin/docker-compose.yml
# docker compose -f docker-compose.yml -f docker-compose.prod.yml config --no-interpolate --no-normalize | sed "s|$(pwd)|.|g" > bin/docker-compose.yml

# Archive all the config files necessary for deployment
tar -cf bin/configs.tar --no-xattrs certs .env -C bin docker-compose.yml

# Clean up
docker rmi $NGINX_IMAGE
docker rmi $REGISTRY_IMAGE
# rm bin/docker-compose.final.yml #TODO: add a clean up script

