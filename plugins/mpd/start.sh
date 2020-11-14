#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_MPD" ]]; then
  echo "MPD is disabled, exiting..."
  exit 0
fi

# --- ENV VARS ---
# SOUND_DEVICE_NAME: Set the device broadcast name for MPD
SOUND_DEVICE_NAME=${SOUND_DEVICE_NAME:-"balenaSound MPD $(hostname | cut -c -4)"}
sed -i 's/$BALENA_SOUND_DEVICE_NAME/'$SOUND_DEVICE_NAME'/' /usr/src/mpd.conf

# set initial volume level
MPD_INITIAL_SOUND_VOLUME=${MPD_INITIAL_SOUND_VOLUME:-"20"}
sed -i 's/$BALENA_MPD_INITIAL_SOUND_VOLUME/'$MPD_INITIAL_SOUND_VOLUME'/' /usr/src/state

echo "Starting MPD plugin..."
echo "Device name: $SOUND_DEVICE_NAME"
echo "Initial volume set to: $MPD_INITIAL_SOUND_VOLUME"

# Start mpd
exec mpd --no-daemon --stderr /usr/src/mpd.conf