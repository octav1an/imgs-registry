#!/bin/sh
set -e

VOLUME_NAME=registry_data
BACKUP_DESTINATION=

ACTION=$1
BACKUP_NAME=$2

if [ "$ACTION" = "restore" ]; then
  echo "restoring registry..."
  docker run --rm \
      -v "$VOLUME_NAME":/backup-volume \
      -v "$(pwd)":/backup \
      busybox \
      tar -xzvf /backup/$BACKUP_NAME --strip-components 1 -C /backup-volume
  exit 0
fi

echo "backing up registry..."
BACKUP_DIR=$BACKUP_DESTINATION || $(pwd)/backup
BACKUP_NAME=$VOLUME_NAME-$(date +%Y-%m-%d_%H-%M-%S).tar.gz
echo $BACKUP_DIR
exit 0
echo 

[ -d "$BACKUP_DIR" ] || mkdir $BACKUP_DIR

docker run --rm \
    -v "$VOLUME_NAME":/backup-volume \
    -v "$BACKUP_DIR":/backup \
    busybox \
    tar -zcf /backup/$BACKUP_NAME /backup-volume

echo "~~ DONE: $BACKUP_NAME created ~~"
