#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_TIDAL" ]]; then
  echo "TIDAL is disabled, exiting..."
  exit 0
fi

# --- ENV VARS ---
# SOUND_DEVICE_NAME: Set the device broadcast name for TIDAL
# SOUND_TIDAL_LOGLEVEL: Set the log-level flag between 0 and 6
# SOUND_TIDAL_WEBSOCKLOG: Set the web socket log level between 0 and 3

SOUND_DEVICE_NAME=${SOUND_DEVICE_NAME:-"balenaSound TIDAL $(hostname | cut -c -4)"}
SOUND_TIDAL_LOGLEVEL=${SOUND_TIDAL_LOGLEVEL:-3}
SOUND_TIDAL_WEBSOCKLOG=${SOUND_TIDAL_WEBSOCKLOG:-0}

# removed flag --netif-for-deviceid wlan0 \
# SOUND_TIDAL_ENABLE_MQA_PASSTHROUGH: Disable volume normalisation
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

# Start TIDAL Connect Application
# We use set/$@ because application for some reason does not like env vars and quote escapes
# Full list of flags for tidal_connect_application are at https://github.com/balenalabs/balena-sound/pull/399#issuecomment-753691047

echo "Starting TIDAL plugin..."
echo "Device name: $SOUND_DEVICE_NAME"

# [[ -n "$SOUND_SPOTIFY_USERNAME" ]] && [[ -n "$SOUND_SPOTIFY_PASSWORD" ]] && echo "Using provided credentials for Spotify login."
# [[ -z "$SOUND_SPOTIFY_DISABLE_NORMALISATION" ]] && echo "Volume normalization enabled."

set -- /usr/ifi/ifi-tidal-release/bin/tidal_connect_application \
			--tc-certificate-path "/usr/ifi/ifi-tidal-release/id_certificate/IfiAudio_ZenStream.dat" \
			-f "$SOUND_DEVICE_NAME" \
			--codec-mpegh true \
			--codec-mqa false \
			--model-name "$SOUND_DEVICE_NAME" \
			--disable-app-security false \
			--disable-web-security false \
			--enable-mqa-passthrough false \
			--log-level "$SOUND_TIDAL_LOGLEVEL" \
			--enable-websocket-log "$SOUND_TIDAL_WEBSOCKLOG"
			"$@"

exec "$@"
