#!/bin/sh

source .env

curl -s http://$PRIVATE_REGISTRY/v2/_catalog | jq '.repositories[]' | while read image; do
  image=$(echo $image | tr -d '"')
  tags=$(curl -s http://$PRIVATE_REGISTRY/v2/$image/tags/list | jq -r '.tags[]')
  echo "~~ $image ~~"
  echo "$tags"
done