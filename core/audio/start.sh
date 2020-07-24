#!/bin/bash
set -e

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
      sed -i "s/%INPUT_SINK%/sink='snapcast'/" "$CONFIG_FILE"
      ;;
  esac
}

function set_output_sink() {
  local OUTPUT="${2:+sink='$2'}"
  sed -i "s/%OUTPUT_SINK%/$OUTPUT/" "$CONFIG_FILE"
}

function reset_sound_config() {
  if [[ -f "$CONFIG_FILE" ]]; then
    rm "$CONFIG_FILE"
  fi 
  cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"
}

# TODO: balenaSound core environment variables - probably getting them from sound-supervisor later on
CONFIG_TEMPLATE=/usr/src/balena-sound.pa.template
CONFIG_FILE=/etc/pulse/balena-sound.pa
MODE="${SOUND_MODE:-MULTI_ROOM}"
OUTPUT=""

if [[ -f /run/pulse/init-sink.pulse ]]; then
  OUTPUT=$(cat /run/pulse/init-sink.pulse)
fi

echo "- Mode: $MODE"
echo "- Init sink: $OUTPUT"

reset_sound_config
set_input_sink "$MODE"
set_output_sink "$OUTPUT"

exec pulseaudio --file /etc/pulse/balena-sound.pa