#!/bin/bash
set -e

# Wait for sound supervisor to start
SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }')"
while ! curl --silent --output /dev/null "$SOUND_SUPERVISOR/ping"; do sleep 5; echo "Waiting for sound supervisor to start"; done

# Get mode from sound supervisor. 
# mode: default to MULTI_ROOM
SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }')"
MODE=$(curl --silent "$SOUND_SUPERVISOR/mode" || true)

# Multi-room server can't run properly in some platforms because of resource constraints, so we disable them
declare -A blacklisted=(
  ["raspberry-pi"]=0
  ["raspberry-pi2"]=1
)

if [[ -n "${blacklisted[$BALENA_DEVICE_TYPE]}" ]]; then
  echo "Multi-room server blacklisted for $BALENA_DEVICE_TYPE. Exiting..."

  if [[ "$MODE" == "MULTI_ROOM" ]]; then
    echo "Multi-room has been disabled on this device type due to performance constraints."
    echo "You should use this device in 'MULTI_ROOM_CLIENT' mode if you have other devices running balenaSound, or 'STANDALONE' mode if this is your only device."
  fi
  exit 0
fi

# Start snapserver
echo "Starting multi-room server..."
echo "$(snapserver --version | head -n 1)"
echo "Mode: $MODE"

if [[ "$MODE" == "MULTI_ROOM" ]]; then
  /usr/bin/snapserver
else
  echo "Multi-room server disabled. Exiting..."
  exit 0
fi