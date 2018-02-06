#!/bin/sh

#
# Script to sync files from the named volume to the host mount.
# This is a companion script to the ldsync setup, which syncs the other way.
#
# Usage: ./lsyncd-rsync.sh /named/volume/path/ /host/mount/path/
#
# Please note that the trailing slashes are required by `rsync`.
#

set -e

stop() {
  docker-compose stop lsyncd
}

sync() {
  docker-compose run \
    --rm \
    --entrypoint rsync \
    lsyncd \
    --archive \
    --chown=1000 \
    --delete \
    "$@"
}

restart() {
  STATUS=$?
  docker-compose start lsyncd
  exit $STATUS
}

trap restart EXIT
stop
sync "$@"
