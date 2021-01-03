#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_TIDAL" ]]; then
  echo "Tidal is disabled, exiting..."
  exit 0
fi

# --- ENV VARS ---
# SOUND_DEVICE_NAME: Set the device broadcast name for Spotify
# SOUND_SPOTIFY_BITRATE: Set the playback bitrate
# SOUND_DEVICE_NAME=${SOUND_DEVICE_NAME:-"balenaSound Spotify $(hostname | cut -c -4)"}
# SOUND_SPOTIFY_BITRATE=${SOUND_SPOTIFY_BITRATE:-160}

# SOUND_SPOTIFY_DISABLE_NORMALISATION: Disable volume normalisation
# if [[ -z "$SOUND_SPOTIFY_DISABLE_NORMALISATION" ]]; then
#  set -- "$@" \
#    --enable-volume-normalisation
# fi

# SOUND_SPOTIFY_USERNAME: Login username for Spotify
# SOUND_SPOTIFY_PASSWORD: Login password for Spotify
# if [[ -n "$SOUND_SPOTIFY_USERNAME" ]] && [[ -n "$SOUND_SPOTIFY_PASSWORD" ]]; then
#  set -- "$@" \
#    --username "$SOUND_SPOTIFY_USERNAME" \
#    --password "$SOUND_SPOTIFY_PASSWORD"
# fi

# Start librespot
# We use set/$@ because librespot for some reason does not like env vars and quote escapes
echo "Starting Tidal plugin..."
# echo "Device name: $SOUND_DEVICE_NAME"
# [[ -n "$SOUND_SPOTIFY_USERNAME" ]] && [[ -n "$SOUND_SPOTIFY_PASSWORD" ]] && echo "Using provided credentials for Spotify login."
# [[ -z "$SOUND_SPOTIFY_DISABLE_NORMALISATION" ]] && echo "Volume normalization enabled."

set -- /usr/ifi/ifi-tidal-release/bin/tidal_connect_application \
			--tc-certificate-path "/usr/ifi/ifi-tidal-release/id_certificate/IfiAudio_ZenStream.dat" \
			--netif-for-deviceid wlan0 \
			-f "balenaSound stream to project" \
			--codec-mpegh true \
			--codec-mqa false \
			--model-name "balenaSound Streamer" \
                        --disable-app-security false \
                        --disable-web-security false \
                        --enable-mqa-passthrough false \
                        --log-level 3
			"$@"

exec "$@"
