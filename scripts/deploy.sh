#!/bin/sh
# Deploys the compose file (and potentially env files) to the server
set -e

source .env

DESTINATION=$USER@$PRIVATE_REGISTRY:services/$PROJECT_NAME

scp bin/configs.tar $DESTINATION
scp bin/images.tar $DESTINATION
