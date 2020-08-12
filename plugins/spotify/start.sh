#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_SPOTIFY" ]]; then
  echo "Spotify is disabled, exiting..."
  exit 0
fi

# Set the device broadcast name for Spotify
if [[ -z "$SOUND_DEVICE_NAME" ]]; then
  SOUND_DEVICE_NAME=$(printf "balenaSound Spotify %s" $(hostname | cut -c -4))
fi

# Set the system volume here
SYSTEM_OUTPUT_VOLUME="${SYSTEM_OUTPUT_VOLUME:-100}"

# Set the Spotify username and password
if [[ ! -z "$SOUND_SPOTIFY_USERNAME" ]] && [[ ! -z "$SOUND_SPOTIFY_PASSWORD" ]]; then
  SPOTIFY_CREDENTIALS="--username \"$SOUND_SPOTIFY_USERNAME\" --password \"$SOUND_SPOTIFY_PASSWORD\""
  printf "%s\n" "Using Spotify login."
fi

# Start librespot
exec "/usr/src/bin/librespot.$BALENA_DEVICE_ARCH" \
  --name "$SOUND_DEVICE_NAME" \
  --bitrate 320 \
  --cache /var/cache/raspotify \
  --enable-volume-normalisation \
  --linear-volume \
  --initial-volume=$SYSTEM_OUTPUT_VOLUME \
  --backend pulseaudio \
  $SPOTIFY_CREDENTIALS
