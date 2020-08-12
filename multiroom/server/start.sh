#!/bin/bash
set -e

# Get mode from sound supervisor. 
# mode: default to MULTI_ROOM
SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):3000"
MODE=$(curl --silent "$SOUND_SUPERVISOR/mode" || true)
MODE="${MODE:-MULTI_ROOM}"

# Multi-room server can't run properly in some platforms because of resource constraints, so we disable them
declare -A blacklisted=(
  ["raspberry"]=0
  ["raspberrypi"]=1
)

if [[ -n "${blacklisted[$BALENA_DEVICE_TYPE]}" ]]; then
  echo "Multi-room server blacklisted for $BALENA_DEVICE_TYPE. Exiting..."
  exit 0
fi

# Start snapserver
echo "Starting multi-room server..."
echo "Mode: $MODE"

if [[ "$MODE" == "MULTI_ROOM" ]]; then
  /usr/bin/snapserver
else
  echo "Multi-room server disabled. Exiting..."
  exit 0
fi