#!/bin/sh

source .ci.env

if [ -z "$1" ]; then
  echo "error: provide user:password combination"
  exit 1
fi

curl -u $1 -s https://$PRIVATE_REGISTRY/v2/_catalog | jq '.repositories[]' | while read image; do
  image=$(echo $image | tr -d '"')
  tags=$(curl -u $1 -s https://$PRIVATE_REGISTRY/v2/$image/tags/list | jq -r '.tags[]')
  echo "~~ $image ~~"
  echo "$tags"
done
