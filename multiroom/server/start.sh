#!/bin/bash
set -e

SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):3000"
MODE=$(curl --silent "$SOUND_SUPERVISOR/mode")

# # snapcast-server disabled by default on Pi 1/2 family
# if [[ $BALENA_DEVICE_TYPE == "raspberry-pi" || $BALENA_DEVICE_TYPE == "raspberry-pi2" ]]; then
#   echo "Multi-room master server functionality is disabled by default on device types: Raspberry Pi (v1/Zero/Zero W) and Raspberry Pi 2."
#   exit 0
# fi

echo "Starting snapserver..."
echo "Mode: $MODE"

# Start snapserver only for MULTI_ROOM mode
if [[ $MODE == "MULTI_ROOM" ]]; then
  /usr/bin/snapserver
else
  echo "Multi-room server disabled. Exiting..."
  exit 0
fi
