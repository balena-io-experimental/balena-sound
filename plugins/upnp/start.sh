#!/usr/bin/env bash
 
#Exit service if client-only mode is enabled 
if [[ $CLIENT_ONLY_MULTI_ROOM == "1" ]]; then
  exit 0
fi

if [[ -z "$DEVICE_NAME" ]]; then
  DEVICE_NAME=$(printf "balenaSound UPnP %s" $(hostname | cut -c -4))
fi

exec /usr/bin/gmediarender -f "$DEVICE_NAME" --port=49494
