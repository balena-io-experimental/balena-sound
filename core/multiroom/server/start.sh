#!/bin/bash
set -e

if [[ -n "$SOUND_MULTIROOM_DISABLE" ]]; then
  echo "Multi-room is disabled, exiting..."
  exit 0
fi

# Multi-room server can't run properly in some platforms because of resource constraints, so we disable them
declare -A blacklisted=(
  ["raspberry-pi"]=0
  ["raspberry-pi2"]=1
)

if [[ -n "${blacklisted[$BALENA_DEVICE_TYPE]}" ]]; then
  echo "Multi-room server is disabled on $BALENA_DEVICE_TYPE device type due to performance constraints. Exiting..."
  exit 0
fi

# Start snapserver
echo "Starting multi-room server..."
/usr/bin/snapserver