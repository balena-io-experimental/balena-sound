#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_SPOTIFY" ]]; then
  echo "Spotify is disabled, exiting..."
  exit 0
fi

# --- ENV VARS ---
# SOUND_DEVICE_NAME: Set the device broadcast name for Spotify
# SOUND_SPOTIFY_BITRATE: Set the playback bitrate
SOUND_DEVICE_NAME=${SOUND_DEVICE_NAME:-"balenaSound Spotify $(echo "$BALENA_DEVICE_UUID" | cut -c -4)"}
SOUND_SPOTIFY_BITRATE=${SOUND_SPOTIFY_BITRATE:-160}

# SOUND_SPOTIFY_DISABLE_NORMALISATION: Disable volume normalisation
if [[ -z "$SOUND_SPOTIFY_DISABLE_NORMALISATION" ]]; then
  set -- "$@" \
    --enable-volume-normalisation
fi

# SOUND_SPOTIFY_USERNAME: Login username for Spotify
# SOUND_SPOTIFY_PASSWORD: Login password for Spotify
if [[ -n "$SOUND_SPOTIFY_USERNAME" ]] && [[ -n "$SOUND_SPOTIFY_PASSWORD" ]]; then
  set -- "$@" \
    --username "$SOUND_SPOTIFY_USERNAME" \
    --password "$SOUND_SPOTIFY_PASSWORD"
fi

# SOUND_SPOTIFY_DISABLE_CACHE: Disable Spotify audio cache
if [[ -z "$SOUND_SPOTIFY_ENABLE_CACHE" ]]; then
  set -- "$@" \
    --disable-audio-cache
fi

# Start librespot
# We use set/$@ because librespot for some reason does not like env vars and quote escapes
echo "Starting Spotify plugin..."
echo "Device name: $SOUND_DEVICE_NAME"
[[ -n "$SOUND_SPOTIFY_USERNAME" ]] && [[ -n "$SOUND_SPOTIFY_PASSWORD" ]] && echo "Using provided credentials for Spotify login."
[[ -z "$SOUND_SPOTIFY_DISABLE_NORMALISATION" ]] && echo "Volume normalization enabled."
[[ -z "$SOUND_SPOTIFY_ENABLE_CACHE" ]] && echo "Spotify audio cache disabled."

set -- /usr/bin/librespot \
  --name "$SOUND_DEVICE_NAME" \
  --bitrate "$SOUND_SPOTIFY_BITRATE" \
  --cache /var/cache/raspotify \
  --volume-ctrl linear \
  "$@"

exec "$@"
