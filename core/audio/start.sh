#!/bin/bash
set -e

# PulseAudio configuration files for balena-sound
CONFIG_TEMPLATE=/usr/src/balena-sound.pa
CONFIG_FILE=/etc/pulse/balena-sound.pa

# Route "balena-sound.input" to the appropriate sink depending on selected mode
# Either "snapcast" fifo sink or "balena-sound.output"
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
      echo "Routing 'balena-sound.input' to 'balena-sound.output'."
      ;;

    ${options["MULTI_ROOM"]} | *)
      sed -i "s/%INPUT_SINK%/sink=\"snapcast\"/" "$CONFIG_FILE"
      echo "Routing 'balena-sound.input' to 'snapcast'."
      ;;
  esac
}

# Route "balena-sound.output" to the appropriate audio hardware
function set_output_sink() {
  local OUTPUT=""

  # If a custom selection was made via AUDIO_OUTPUT env var
  # audio block outputs the sink name to this file
  # Otherwise, use sink #0 which is always the PulseAudio default
  local SINK_FILE=/run/pulse/pulseaudio.sink
  if [[ -f "$SINK_FILE" ]]; then
    OUTPUT=$(cat "$SINK_FILE")
  fi
  OUTPUT="${OUTPUT:-0}"
  sed -i "s/%OUTPUT_SINK%/sink=\"$OUTPUT\"/" "$CONFIG_FILE"
  echo "Routing 'balena-sound.output' to $OUTPUT."
}

function reset_sound_config() {
  if [[ -f "$CONFIG_FILE" ]]; then
    rm "$CONFIG_FILE"
  fi 
  cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"
}

# Get mode from sound supervisor. 
# mode: default to MULTI_ROOM
SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):3000"
MODE=$(curl --silent "$SOUND_SUPERVISOR/mode" || true)
MODE="${MODE:-MULTI_ROOM}"

# Audio routing: route intermediate balena-sound input/output sinks
echo "Setting audio routing rules. Note that this can be changed after startup."
reset_sound_config
set_input_sink "$MODE"
set_output_sink

exec pulseaudio --file /etc/pulse/balena-sound.pa