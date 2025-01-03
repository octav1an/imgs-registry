#!/bin/sh

VOLUME_NAME=local-registry_data

ACTION=$1
BACKUP_NAME=$2

if [ -z $ACTION ]; then
  echo "backing up registry..."
  docker run --rm \
      -v "$VOLUME_NAME":/backup-volume \
      -v "$(pwd)":/backup \
      busybox \
      tar -zcvf /backup/backup-$(date +%Y-%m-%d_%H-%M-%S).tar.gz /backup-volume
fi

if [ "$ACTION" = "restore" ]; then
  echo "restoring registry..."
  docker run --rm \
      -v "$VOLUME_NAME":/backup-volume \
      -v "$(pwd)":/backup \
      busybox \
      tar -xzvf /backup/$BACKUP_NAME --strip-components 1 -C /backup-volume
else
  echo "action not allowed"
fi
