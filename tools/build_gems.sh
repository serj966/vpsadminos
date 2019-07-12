#!/bin/sh -x

if [ $# -lt 3 ] ; then
  echo "Usage: $0 <make> <build-id> all | <gems>"
  exit 1
fi

MAKE="$1"
BUILD_ID="$2"
shift 2

export GEMINABOX_HOST=localhost
export GEMINABOX_PORT=4567
export GEMINABOX_URL="http://$GEMINABOX_HOST:$GEMINABOX_PORT"

# START RACKUP
rackup -o $GEMINABOX_HOST -p $GEMINABOX_PORT geminabox.ru &
RACKUP_PID=$!

# BUILD GEMS
$MAKE -f Makefile.gems "$@" BUILD_ID="$BUILD_ID"

# STOP RACKUP
kill -s INT $RACKUP_PID
wait $RACKUP_PID
exit
