#!/usr/bin/env bash

#Exit service if client-only mode is enabled 
if [[ $CLIENT_ONLY_MULTI_ROOM == "1" ]]; then
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

# Start pulseaudio for librespot to use
pulseaudio --start --system=true

# Start librespot
exec /usr/src/librespot/target/release/librespot --name "$DEVICE_NAME" --bitrate 320 --cache /var/cache/raspotify --enable-volume-normalisation --volume-ctrl linear --initial-volume=$SYSTEM_OUTPUT_VOLUME $SOUND_SPOTIFY_CREDENTIALS --backend pulseaudio
