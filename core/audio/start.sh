#!/bin/bash
set -e

CONFIG_TEMPLATE=/usr/src/balena-sound.pa.template
CONFIG_FILE=/etc/pulse/balena-sound.pa
SINK_FILE=/run/pulse/pulseaudio.sink

function set_input_sink() {
  local MODE="$1"

  declare -A options=(
      ["MULTI_ROOM"]=0
      ["MULTI_ROOM_CLIENT"]=1
      ["STANDALONE"]=2
    )

  case "${options[$MODE]}" in
    ${options["STANDALONE"]} | ${options["MULTI_ROOM_CLIENT"]})
      sed -i "s/%INPUT_SINK%/sink='balena-sound.output'/" "$CONFIG_FILE"
      ;;

    ${options["MULTI_ROOM"]} | *)
      sed -i "s/%INPUT_SINK%/sink=\"snapcast\"/" "$CONFIG_FILE"
      ;;
  esac
}

function set_output_sink() {
  local OUTPUT="${1:-0}"
  sed -i "s/%OUTPUT_SINK%/sink=\"$OUTPUT\"/" "$CONFIG_FILE"
}

function reset_sound_config() {
  if [[ -f "$CONFIG_FILE" ]]; then
    rm "$CONFIG_FILE"
  fi 
  cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"
}

SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):3000"
MODE=$(curl --silent "$SOUND_SUPERVISOR/mode")
OUTPUT=""

if [[ -f "$SINK_FILE" ]]; then
  OUTPUT=$(cat "$SINK_FILE")
fi

echo "- Mode: $MODE"
echo "- Default sink: $OUTPUT"

# Audio routing: route intermediate balena-sound input/output sinks
reset_sound_config
set_input_sink "$MODE"
set_output_sink "$OUTPUT"

exec pulseaudio --file /etc/pulse/balena-sound.pa