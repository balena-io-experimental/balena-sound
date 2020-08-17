#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_AIRPLAY" ]]; then
  echo "Airplay is disabled, exiting..."
  exit 0
fi

# Set the device broadcast name for AirPlay
if [[ -z "$SOUND_DEVICE_NAME" ]]; then
  SOUND_DEVICE_NAME=$(printf "balenaSound Airplay %s" $(hostname | cut -c -4))
fi

# Wait for audioblock to start. This is a bit hacky, but necessary for the time being as
# shairport-sync will fail silently if audioblock is not ready when it starts up
# See: https://github.com/mikebrady/shairport-sync/issues/1054
while [[ "$(curl --silent --head --output /dev/null --write-out '%{http_code}' --max-time 2000 'http://localhost:3000/audio')" != "200" ]]; do sleep 5; echo "Waiting for audioblock to start..."; done

# Start AirPlay
exec shairport-sync \
  --name "$SOUND_DEVICE_NAME" \
  --output pa \
  echo "Shairport-sync started. Device is discoverable as \"%s\"\n" "$SOUND_DEVICE_NAME"