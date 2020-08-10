#!/usr/bin/env bash

#Exit service if client-only mode is enabled
SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):3000"
MODE=$(curl --silent "$SOUND_SUPERVISOR/mode")
if [[ $MODE == "MULTI_ROOM_CLIENT" ]]; then
  exit 0
fi

# Set the device broadcast name for Spotify
if [[ -z "$DEVICE_NAME" ]]; then
  DEVICE_NAME=$(printf "balenaSound Spotify %s" $(hostname | cut -c -4))
fi

# Set the system volume here
SYSTEM_OUTPUT_VOLUME="${SYSTEM_OUTPUT_VOLUME:-100}"

# Set the Spotify username and password
if [[ ! -z "$SOUND_SPOTIFY_LOGIN" ]] && [[ ! -z "$SOUND_SPOTIFY_PASSWORD" ]]; then
  SOUND_SPOTIFY_CREDENTIALS="--username \"$SPOTIFY_LOGIN\" --password \"$SPOTIFY_PASSWORD\""
  printf "%s\n" "Using Spotify login."
fi

# Start librespot
exec "/usr/src/bin/librespot.$BALENA_DEVICE_ARCH" \
  --name "$DEVICE_NAME" \
  --bitrate 320 \
  --cache /var/cache/raspotify \
  --enable-volume-normalisation \
  --linear-volume \
  --initial-volume=$SYSTEM_OUTPUT_VOLUME $SOUND_SPOTIFY_CREDENTIALS \
  --backend pulseaudio
