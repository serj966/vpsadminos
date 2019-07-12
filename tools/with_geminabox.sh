#!/bin/sh -x

[ "$GEMINABOX_HOST" == "" ] && export GEMINABOX_HOST=localhost
[ "$GEMINABOX_PORT" == "" ] && export GEMINABOX_PORT=4567
export GEMINABOX_URL="http://$GEMINABOX_HOST:$GEMINABOX_PORT"

# Start rackup
rackup -o $GEMINABOX_HOST -p $GEMINABOX_PORT geminabox.ru &
RACKUP_PID=$!

# Call program while geminabox is running
"$@"
sleep 3

# Stop rackup
kill -s INT $RACKUP_PID
wait $RACKUP_PID
exit
