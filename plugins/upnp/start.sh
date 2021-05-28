#!/usr/bin/env bash

# --- ENV VARS ---
# SOUND_DEVICE_NAME: Set the device broadcast name for UPnP
SOUND_DEVICE_NAME=${SOUND_DEVICE_NAME:-"balenaSound UPnP $(echo "$BALENA_DEVICE_UUID" | cut -c -4)"}

echo "Starting UPnP plugin..."
echo "Device name: $SOUND_DEVICE_NAME"
echo "Using upnp UUID : $BALENA_DEVICE_UUID"

exec /usr/bin/gmediarender \
  --friendly-name "$SOUND_DEVICE_NAME" \
  -u "$BALENA_DEVICE_UUID" \
  --port=49494
