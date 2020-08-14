#!/usr/bin/env bash
 
if [[ -n "$SOUND_DISABLE_UPNP" ]]; then
  echo "UPnP is disabled, exiting..."
  exit 0
fi

# Set the device broadcast name for UPnP
if [[ -z "$SOUND_DEVICE_NAME" ]]; then
  SOUND_DEVICE_NAME=$(printf "balenaSound UPnP %s" $(hostname | cut -c -4))
fi

exec /usr/bin/gmediarender \
  --friendly-name "$SOUND_DEVICE_NAME" \
  --port=49494
