#!/usr/bin/env bash
 
# snapcast-server disabled by default on Pi 1 family
if [[ $BALENA_DEVICE_TYPE == "raspberry-pi" ]]; then
  echo "Multi-room master server functionality is disabled by default on device type: Raspberry Pi (v1/Zero/Zero W)."
  exit 0
fi

# Start snapserver if multi room is enabled
if [[ -z $DISABLE_MULTI_ROOM ]]; then
  snapserver
else
  echo "Multi-room audio is disabled, not starting snapserver."
  exit 0
fi
