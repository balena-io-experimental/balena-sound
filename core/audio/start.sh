#!/bin/bash
set -e

# pactl load-module module-null-sink sink_name=balena-sound

# load-module module-loopback source="virtual-sink.monitor"


# declare -A modes=(
#   ["STANDALONE"]=0
#   ["MULTI_ROOM"]=1
# )

# case "${modes[$SOUND_MODE]}" in
#   # Standalone
#   ${options["STANDALONE"]})
#     ;;

#   # Multiroom: route all audio by default to snapcast
#   ${options["MULTI_ROOM"]} | *)
#     pactl load-module module-pipe-sink file=/var/cache/snapcast/snapfifo sink_name=snapcast format=s16le rate=44100
#     pactl set-default-sink snapcast
#     ;;
# esac

# exec pulseaudio
# pulseaudio