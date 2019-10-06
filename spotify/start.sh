#!/usr/bin/env bash

if [[ -z "$BLUETOOTH_DEVICE_NAME" ]]; then
  BLUETOOTH_DEVICE_NAME=$(printf "balenaSound %s" $(hostname | cut -c -4))
fi

./usr/bin/librespot  --name "$BLUETOOTH_DEVICE_NAME" $BACKEND_ARGS --bitrate ${BITRATE} $CACHE_ARGS $VOLUME_ARGS
