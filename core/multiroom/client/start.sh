#!/usr/bin/env bash
set -e

# Get mode and snapserver from sound supervisor. 
# mode: default to MULTI_ROOM
# snapserver: default to multiroom-server (local)
SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):3000"
MODE=$(curl --silent "$SOUND_SUPERVISOR/mode" || true)
MODE="${MODE:-MULTI_ROOM}"
SNAPSERVER=$(curl --silent "$SOUND_SUPERVISOR/multiroom/master" || true)
SNAPSERVER="${SNAPSERVER:-multiroom-server}"

# SOUND_MULTIROOM_LATENCY: compensate for speaker hardware sync issues
LATENCY=${SOUND_MULTIROOM_LATENCY:+"--latency $SOUND_MULTIROOM_LATENCY"}

echo "Starting multi-room client..."
echo "Mode: $MODE"
echo "Target snapcast server: $SNAPSERVER"

# Start snapclient
if [[ "$MODE" == "MULTI_ROOM" || "$MODE" == "MULTI_ROOM_CLIENT" ]]; then
  /usr/bin/snapclient --host $SNAPSERVER $LATENCY
else
  echo "Multi-room client disabled. Exiting..."
  exit 0
fi