#!/usr/bin/env bash

#Check for incompatible multi room and client-only setting
if [[ -n $DISABLE_MULTI_ROOM ]] && [[ $CLIENT_ONLY_MULTI_ROOM == "1" ]]; then
  echo “DISABLE_MULTI_ROOM and CLIENT_ONLY_MULTI_ROOM cannot be set simultaneously. Ignoring client-only mode.”
fi

#Exit service if client-only mode is enabled
if [[ -z $DISABLE_MULTI_ROOM ]] && [[ $CLIENT_ONLY_MULTI_ROOM == "1" ]]; then
  exit 0
fi


# Set the device broadcast name for AirPlay
if [[ -z "$DEVICE_NAME" ]]; then
  DEVICE_NAME=$(printf "balenaSound Airplay %s" $(hostname | cut -c -4))
fi

# Use pipe output if multi room is enabled
# Don't pipe for Pi 1/2 family devices since snapcast-server is disabled by default
if [[ -z $DISABLE_MULTI_ROOM ]] && [[ $BALENA_DEVICE_TYPE != "raspberry-pi" || $BALENA_DEVICE_TYPE != "raspberry-pi2" ]]; then
  SHAIRPORT_BACKEND="-o pipe -- /var/cache/snapcast/snapfifo"
fi

# Start AirPlay
exec shairport-sync -a "$DEVICE_NAME" $SHAIRPORT_BACKEND | printf "Device is discoverable as \"%s\"\n" "$DEVICE_NAME"