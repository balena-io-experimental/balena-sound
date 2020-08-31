#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_SPOTIFY" ]]; then
  echo "Spotify is disabled, exiting..."
  exit 0
fi

# --- ENV VARS ---
# SOUND_DEVICE_NAME: Set the device broadcast name for Spotify
# SOUND_SPOTIFY_BITRATE: Set the playback bitrate
SOUND_DEVICE_NAME=${SOUND_DEVICE_NAME:-"balenaSound Spotify $(hostname | cut -c -4)"}
SOUND_SPOTIFY_BITRATE=${SOUND_SPOTIFY_BITRATE:-160}

# SOUND_SPOTIFY_DISABLE_NORMALISATION: Disable volume normalisation
if [[ -z "$SOUND_SPOTIFY_DISABLE_NORMALISATION" ]]; then
  SPOTIFY_NORMALIZATION="--enable-normalisation"
else
  SPOTIFY_NORMALIZATION=""
fi

# SOUND_SPOTIFY_USERNAME: Login username for Spotify
# SOUND_SPOTIFY_PASSWORD: Login password for Spotify
if [[ -n "$SOUND_SPOTIFY_USERNAME" ]] && [[ -n "$SOUND_SPOTIFY_PASSWORD" ]]; then
  SPOTIFY_CREDENTIALS="--username \"$SOUND_SPOTIFY_USERNAME\" --password \"$SOUND_SPOTIFY_PASSWORD\""
fi

echo "Starting Spotify plugin..."
echo "Device name: $SOUND_DEVICE_NAME"
[[ -n ${SPOTIFY_CREDENTIALS} ]] && echo "Using provided credentials for Spotify login."

# Start librespot
exec /usr/bin/librespot \
  --name "$SOUND_DEVICE_NAME" \
  --bitrate "$SOUND_SPOTIFY_BITRATE" \
  --cache /var/cache/raspotify \
  --linear-volume \
  "$SPOTIFY_NORMALISATION" \
  "$SPOTIFY_CREDENTIALS"