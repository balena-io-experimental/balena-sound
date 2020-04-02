#!/usr/bin/env bash

# Set the device broadcast name for AirPlay
if [[ -z "$DEVICE_NAME" ]]; then
  DEVICE_NAME=$(printf "balenaSound Airplay %s" $(hostname | cut -c -4))
fi

# Use pipe output if multi room is enabled
# Don't pipe for Pi 1 family devices since snapcast-server is disabled by default
if [[ -z $DISABLE_MULTI_ROOM ]] && [[ $BALENA_DEVICE_TYPE != "raspberry-pi" ]]; then
  SHAIRPORT_BACKEND="-o pipe -- /var/cache/snapcast/snapfifo"
fi

# Start AirPlay
exec shairport-sync -a "$DEVICE_NAME" $SHAIRPORT_BACKEND | printf "Device is discoverable as \"%s\"\n" "$DEVICE_NAME"
