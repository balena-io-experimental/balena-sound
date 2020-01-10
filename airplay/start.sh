#!/usr/bin/env bash

# Set the device broadcast name for AirPlay
if [[ -z "$BLUETOOTH_DEVICE_NAME" ]]; then
  BLUETOOTH_DEVICE_NAME=$(printf "balenaSound Airplay %s" $(hostname | cut -c -4))
fi

# Use pipe output if multi room is enabled
# Don't pipe for Pi 1 family devices since snapcast-server is disabled by default
if [[ -z $DISABLE_MULTI_ROOM ]] && [[ $BALENA_DEVICE_TYPE != "raspberry-pi" ]]; then
  SHAIRPORT_BACKEND="-o pipe -- /var/cache/snapcast/snapfifo"
fi

# Start AirPlay
exec shairport-sync -a "$BLUETOOTH_DEVICE_NAME" $SHAIRPORT_BACKEND | printf "Device is discoverable as \"%s\"\n" "$BLUETOOTH_DEVICE_NAME"