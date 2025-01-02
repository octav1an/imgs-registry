#!/bin/sh
# Release the new version of the service (script should be copied on remote)

set -e

# TODO: make a backup of the existing images for a rollback

docker load -i images.tar
tar -xvf configs.tar # unzip the configs files

docker compose up -d
