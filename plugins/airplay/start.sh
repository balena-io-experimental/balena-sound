#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_AIRPLAY" ]]; then
  echo "Airplay is disabled, exiting..."
  exit 0
fi

# --- ENV VARS ---
# SOUND_DEVICE_NAME: Set the device broadcast name for AirPlay
SOUND_DEVICE_NAME=${SOUND_DEVICE_NAME:-"balenaSound AirPlay $(echo "$BALENA_DEVICE_UUID" | cut -c -4)"}

echo "Starting AirPlay plugin..."
echo "Device name: $SOUND_DEVICE_NAME"

# Wait for audioblock to start. This is a bit hacky, but necessary for the time being as
# shairport-sync will fail silently if audioblock is not ready when it starts up
# See: https://github.com/mikebrady/shairport-sync/issues/1054
# Remove when above issue is addressed
SOUND_SUPERVISOR_PORT=${SOUND_SUPERVISOR_PORT:-80}
SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):$SOUND_SUPERVISOR_PORT"
while ! curl --silent --output /dev/null "$SOUND_SUPERVISOR/ping"; do sleep 5; echo "Waiting for audioblock to start..."; done

# Start AirPlay
exec shairport-sync \
  --name "$SOUND_DEVICE_NAME" \
  --output pa \
  | echo "Shairport-sync started. Device is discoverable as $SOUND_DEVICE_NAME"