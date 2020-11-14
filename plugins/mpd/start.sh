#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_MPD" ]]; then
  echo "MPD is disabled, exiting..."
  exit 0
fi

echo "Starting MPD plugin..."

# Start mpd
exec mpd --no-daemon --stderr /usr/src/mpd.conf