#!/usr/bin/env bash

#Exit service if client-only mode is enabled
SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):3000"
MODE=$(curl --silent "$SOUND_SUPERVISOR/mode")
if [[ $MODE == "MULTI_ROOM_CLIENT" ]]; then
  exit 0
fi

# Set the device broadcast name for AirPlay
if [[ -z "$DEVICE_NAME" ]]; then
  DEVICE_NAME=$(printf "balenaSound Airplay %s" $(hostname | cut -c -4))
fi

# Use pipe output if multi room is enabled
# Don't pipe for Pi 1/2 family devices since snapcast-server is disabled by default
if [[ -z $DISABLE_MULTI_ROOM ]] && ! [[ $BALENA_DEVICE_TYPE == "raspberry-pi" || $BALENA_DEVICE_TYPE == "raspberry-pi2" ]]; then
  SHAIRPORT_BACKEND="-o pipe -- /var/cache/snapcast/snapfifo"
fi

# Start AirPlay
exec shairport-sync -a "$DEVICE_NAME" $SHAIRPORT_BACKEND | printf "Device is discoverable as \"%s\"\n" "$DEVICE_NAME"