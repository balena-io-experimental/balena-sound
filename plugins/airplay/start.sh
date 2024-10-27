#!/usr/bin/env sh

if [[ -n "$SOUND_DISABLE_AIRPLAY" ]]; then
  echo "Airplay is disabled, exiting..."
  exit 0
fi

# --- ENV VARS ---
# SOUND_DEVICE_NAME: Set the device broadcast name for AirPlay
SOUND_DEVICE_NAME=${SOUND_DEVICE_NAME:-"balenaSound AirPlay $(echo "$BALENA_DEVICE_UUID" | cut -c -4)"}

echo "Starting AirPlay plugin..."
echo "Device name: $SOUND_DEVICE_NAME"

# Check if LATENCY_OFFSET is set
if [[ -n "$SOUND_AIRPLAY_LATENCY_OFFSET" ]]; then
    # File to modify
    file="/etc/shairport-sync.conf"

    # Use sed to replace the value in the specified line
    sed -i "s|//[[:space:]]*audio_backend_latency_offset_in_seconds[[:space:]]*=.*;|	audio_backend_latency_offset_in_seconds = $SOUND_AIRPLAY_LATENCY_OFFSET;|" "$file"

    echo "Updated audio_backend_latency_offset_in_seconds to $LATENCY_OFFSET in $file"
fi


# Start AirPlay
echo "Starting Shairport Sync"
exec shairport-sync \
  --name "$SOUND_DEVICE_NAME" \
  --output alsa \
  -- -d pulse \
  | echo "Shairport-sync started. Device is discoverable as $SOUND_DEVICE_NAME"
