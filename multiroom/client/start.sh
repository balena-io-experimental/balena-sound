#!/usr/bin/env bash
set -e

SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):3000"
MODE=$(curl --silent "$SOUND_SUPERVISOR/mode")
SNAPSERVER=$(curl --silent "$SOUND_SUPERVISOR/multiroom/master")

# MULTI_ROOM_LATENCY: compensate for speaker hardware sync issues
LATENCY=${MULTI_ROOM_LATENCY:+"--latency $MULTI_ROOM_LATENCY"}

echo "Starting snapclient..."
echo "Mode: $MODE"
echo "Target snapcast server: $SNAPSERVER"

# Start snapclient if multi room is enabled
if [[ $MODE == "MULTI_ROOM" || $MODE == "MULTI_ROOM_CLIENT" ]]; then
  /usr/bin/snapclient --host $SNAPSERVER $LATENCY
else
  echo "Multi-room client disabled. Exiting..."
  exit 0
fi