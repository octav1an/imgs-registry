#!/bin/sh

VOLUME_NAME=local-registry_data

ACTION=$1

if [ -z $ACTION ]; then
  echo "backing up registry..."
  docker run --rm \
      -v "$VOLUME_NAME":/backup-volume \
      -v "$(pwd)":/backup \
      busybox \
      tar -zcvf /backup/my-backup.tar.gz /backup-volume
fi

if [ "$ACTION" == "restore" ]; then
  echo "restoring registry..."
  docker run --rm \
      -v "$VOLUME_NAME":/backup-volume \
      -v "$(pwd)":/backup \
      busybox \
      tar -xzvf /backup/my-backup.tar.gz --strip-components 1 -C /backup-volume
else
  echo "action not allowed"
fi
