#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_AIRPLAY" ]]; then
  echo "Airplay is disabled, exiting..."
  exit 0
fi

# Set the device broadcast name for AirPlay
if [[ -z "$SOUND_DEVICE_NAME" ]]; then
  SOUND_DEVICE_NAME=$(printf "balenaSound Airplay %s" $(hostname | cut -c -4))
fi

# Start AirPlay
exec shairport-sync \
  --name "$SOUND_DEVICE_NAME" \
  --output pa