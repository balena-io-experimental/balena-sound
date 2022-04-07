#!/usr/bin/env bash
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

# Get mode and snapserver from sound-supervisor.
# If sound-supervisor is not running default to multiroom-server (local) as it will be overriden regardless once sound-supervisor starts.
# TODO: consider adding back the wait on sound-supervisor as multiroom won't work regardless if it doesn't start.
SOUND_SUPERVISOR_PORT=${SOUND_SUPERVISOR_PORT:-80}
SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):$SOUND_SUPERVISOR_PORT"
SNAPSERVER=$(curl --silent "$SOUND_SUPERVISOR/device/multiroom" || true)
SNAPSERVER=${SNAPSERVER:-"multiroom-server"}
SNAPSERVER_PORT="1704"

# --- ENV VARS ---
# SOUND_MULTIROOM_LATENCY: latency in milliseconds to compensate for speaker hardware sync issues
LATENCY=${SOUND_MULTIROOM_LATENCY:+"--latency $SOUND_MULTIROOM_LATENCY"}

echo "Starting multi-room client..."
echo "- Target snapcast server: $SNAPSERVER"

# Set the snapcast device name for https://github.com/balenalabs/balena-sound/issues/332
if [[ -z $SOUND_DEVICE_NAME ]]; then
    SNAPCAST_CLIENT_ID=$BALENA_DEVICE_UUID
else
    # The sed command replaces invalid host name characters with dash
    SNAPCAST_CLIENT_ID=$(echo $SOUND_DEVICE_NAME | sed -e 's/[^A-Za-z0-9.-]/-/g')
fi

# Start snapclient
# Polling the snapserver port is less resource intensive than letting the service restart itself if the snapserver is not running
echo "Attempting to connect to snapserver at $SNAPSERVER:$SNAPSERVER_PORT..."
while ! nc -z "$SNAPSERVER:$SNAPSERVER_PORT"; do sleep 5; done
echo "Connection established successfully!"
/usr/bin/snapclient --host $SNAPSERVER $LATENCY --hostID $SNAPCAST_CLIENT_ID --logfilter *:error
