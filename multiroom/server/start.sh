#!/bin/bash
set -e

SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):3000"
MODE=$(curl --silent "$SOUND_SUPERVISOR/mode")
MULTIROOM_DISABLED=$(curl --silent "$SOUND_SUPERVISOR/multiroom/disabled")

echo "Starting multi-room server..."
echo "Mode: $MODE"
echo "Disabled: $MULTIROOM_DISABLED"

# Start snapserver only for MULTI_ROOM mode
if [[ "$MODE" == "MULTI_ROOM" ]]; then
  if [[ "$MULTIROOM_DISABLED" == "false" ]]; then
    /usr/bin/snapserver
  else
    echo "Multi-room server blacklisted for $BALENA_DEVICE_TYPE. Exiting..."
    exit 0
  fi
else
  echo "Multi-room server disabled. Exiting..."
  exit 0
fi