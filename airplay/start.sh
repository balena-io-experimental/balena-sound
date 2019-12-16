#!/usr/bin/env bash

if [[ -z "$BLUETOOTH_DEVICE_NAME" ]]; then
  BLUETOOTH_DEVICE_NAME=$(printf "balenaSound %s" $(hostname | cut -c -4))
fi

exec shairport-sync -a "$BLUETOOTH_DEVICE_NAME" | printf "Device is discoverable as \"%s\"\n" "$BLUETOOTH_DEVICE_NAME"