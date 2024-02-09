#!/usr/bin/env bash

if [[ -n "$SOUND_DISABLE_MPD" ]]; then
  echo "MPD is disabled, exiting..."
  exit 0
fi


DEVNAME=${SOUND_MPD_DEVNAME:-"/dev/sda1"}

if [[ -z $DEVNAME ]]; then
  echo "Invalid device name: $DEVNAME"
  exit 1
fi

if [[ ! -e "$DEVNAME" ]]; then
  echo "Device $DEVNAME not found, exiting..."
  exit 1
fi

# Mount external filesystem
# Doc: https://docs.balena.io/learn/develop/runtime/#mounting-external-storage-media
if findmnt -rno SOURCE,TARGET $DEVNAME > /dev/null; then
    echo "Device $DEVNAME is already mounted!"
else
    DESTINATION=/var/lib/mpd
    echo "Mounting $DEVNAME to $DESTINATION"
    mkdir -p $DESTINATION 
    mount "$DEVNAME" "$DESTINATION"
fi

mkdir -p $DESTINATION/playlists
mkdir -p $DESTINATION/music

# Start MPD
mpdcommand=$(command -v mpd)

# SOUND_MPD_VERBOSE: Run mpc in verbose mode
if [[ -z ${SOUND_MPD_VERBOSE+x} ]]; then
  set -- "$@" \
    --verbose
fi


set -- $mpdcommand --no-daemon --stderr 
 "$@"
exec "$@"
