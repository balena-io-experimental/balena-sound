#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_SPOTIFY" ]]; then
  echo "Spotify is disabled, exiting..."
  exit 0
fi

# --- ENV VARS ---
# SOUND_DEVICE_NAME: Set the device broadcast name for Spotify
SOUND_DEVICE_NAME=${SOUND_DEVICE_NAME:-"balenaSound Spotify $(hostname | cut -c -4)"}

# SOUND_SPOTIFY_USERNAME: Login username for Spotify
# SOUND_SPOTIFY_PASSWORD: Login password for Spotify
if [[ ! -z "$SOUND_SPOTIFY_USERNAME" ]] && [[ ! -z "$SOUND_SPOTIFY_PASSWORD" ]]; then
  SPOTIFY_CREDENTIALS="--username \"$SOUND_SPOTIFY_USERNAME\" --password \"$SOUND_SPOTIFY_PASSWORD\""
fi

echo "Starting Spotify plugin..."
echo "Device name: $SOUND_DEVICE_NAME"
[[ -n ${SPOTIFY_CREDENTIALS} ]] && echo "Using provided credentials for Spotify login."

# Start librespot
exec /usr/bin/librespot \
  --name "$SOUND_DEVICE_NAME" \
  --bitrate 320 \
  --cache /var/cache/raspotify \
  --enable-volume-normalisation \
  --linear-volume \
  $SPOTIFY_CREDENTIALS
