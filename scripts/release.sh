#!/bin/sh
# Release the new version of the service (script should be copied on remote)
# To rollback use 'rollback' arg

set -e

artifacts="certs docker-compose.yml"
BACKUP_DIR=release.old


rollback() {
  if [ ! -d $BACKUP_DIR ]; then
    echo "error: '$BACKUP_DIR' folder with backup artifacts doesn't exist"
    exit 1
  fi

  echo "starting rollback..."
  for artifact in $artifacts
  do
    cp -r $BACKUP_DIR/$artifact ./
  done
  echo "ended rollback"
  
  docker compose down
  docker compose up -d
}

if [ "$1" = "rollback" ]; then
  rollback
  exit 0
fi

# make a backup of the existing images for a rollback
[ ! -d "$BACKUP_DIR" ] && mkdir $BACKUP_DIR

for artifact in $artifacts
do
  cp -r $artifact $BACKUP_DIR
done

docker load -i images.tar
tar -xvf configs.tar # unzip the configs files

docker compose down
docker compose up -d
