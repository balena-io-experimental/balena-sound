#!/usr/bin/env bash
set -e

# Wait for sound supervisor to start
SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):3000"
while ! curl --silent --output /dev/null "$SOUND_SUPERVISOR/ping"; do sleep 5; echo "Waiting for sound supervisor to start"; done

# Get mode and snapserver from sound supervisor
# mode: default to MULTI_ROOM
# snapserver: default to multiroom-server (local)
MODE=$(curl --silent "$SOUND_SUPERVISOR/mode" || true)
SNAPSERVER=$(curl --silent "$SOUND_SUPERVISOR/multiroom/master" || true)

# --- ENV VARS ---
# SOUND_MULTIROOM_LATENCY: latency in milliseconds to compensate for speaker hardware sync issues
LATENCY=${SOUND_MULTIROOM_LATENCY:+"--latency $SOUND_MULTIROOM_LATENCY"}

echo "Starting multi-room client..."
echo "Mode: $MODE"
echo "Target snapcast server: $SNAPSERVER"

# Start snapclient
if [[ "$MODE" == "MULTI_ROOM" || "$MODE" == "MULTI_ROOM_CLIENT" ]]; then
  /usr/bin/snapclient --host $SNAPSERVER $LATENCY --logfilter *:notice
else
  echo "Multi-room client disabled. Exiting..."
  exit 0
fi