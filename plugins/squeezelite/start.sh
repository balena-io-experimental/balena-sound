#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_SQUEEZELITE" ]]; then
  echo "Squeezelite is disabled, exiting..."
  exit 0
fi

# integrity check
SHA_RES=$(sha1sum -c squeezelite.sha1)
if [ "$SHA_RES" == "squeezelite.tar.gz: OK" ]; then
    echo "Integrity check passed.";
else
    echo "Integrity check failed. Stoped execution.";
    exit 0
fi

# --- ENV VARS ---
# SOUND_DEVICE_NAME: Set the device broadcast name for Squeezelite
SOUND_DEVICE_NAME=${SOUND_DEVICE_NAME:-"balenaSound Squeezelite $(hostname | cut -c -4)"}

while [[ "$(curl --silent --head --output /dev/null --write-out '%{http_code}' --max-time 2000 'http://localhost:3000/audio')" != "200" ]]; do sleep 5; echo "Waiting for audioblock to start..."; done

echo "Starting Squeezelite plugin..."
echo "Device name: $SOUND_DEVICE_NAME"

/usr/src/squeezelite -n "$SOUND_DEVICE_NAME"