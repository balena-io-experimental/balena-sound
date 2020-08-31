#!/bin/bash
set -e

# PulseAudio configuration files for balena-sound
CONFIG_TEMPLATE=/usr/src/balena-sound.pa
CONFIG_FILE=/etc/pulse/balena-sound.pa

# Route "balena-sound.input" to the appropriate sink depending on selected mode
# Either "snapcast" fifo sink or "balena-sound.output"
function route_input_sink() {
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

# Route any existing source to the input router ("balena-sound.input")
function route_input_source() {
  local INPUT_DEVICE=$(arecord -l | awk '/card [0-9]:/ { print $3 }')

  if [[ -n "$INPUT_DEVICE" ]]; then
    local INPUT_DEVICE_FULLNAME="alsa_input.$INPUT_DEVICE.analog-stereo"
    echo "Routing audio from '$INPUT_DEVICE_FULLNAME' into 'balena-sound.input sink'"
    echo -e "\nload-module module-loopback source='$INPUT_DEVICE_FULLNAME' sink='balena-sound.input'" >> "$CONFIG_FILE"
  fi

}

# Route "balena-sound.output" to the appropriate audio hardware
function route_output_sink() {
  local OUTPUT=""

  # Audio block outputs the default sink name to this file
  # If file doesn't exist, default to sink #0. This shouldn't happen though
  local SINK_FILE=/run/pulse/pulseaudio.sink
  if [[ -f "$SINK_FILE" ]]; then
    OUTPUT=$(cat "$SINK_FILE")
  fi
  OUTPUT="${OUTPUT:-0}"
  sed -i "s/%OUTPUT_SINK%/sink=\"$OUTPUT\"/" "$CONFIG_FILE"
  echo "Routing 'balena-sound.output' to '$OUTPUT'."
}

function reset_sound_config() {
  if [[ -f "$CONFIG_FILE" ]]; then
    rm "$CONFIG_FILE"
  fi 
  cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"
}

# Wait for sound supervisor to start
SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):3000"
while ! curl --silent --output /dev/null "$SOUND_SUPERVISOR/ping"; do sleep 5; echo "Waiting for sound supervisor to start"; done

# Get mode from sound supervisor. 
# mode: default to MULTI_ROOM
SOUND_SUPERVISOR="$(ip route | awk '/default / { print $3 }'):3000"
MODE=$(curl --silent "$SOUND_SUPERVISOR/mode" || true)

# --- ENV VARS ---
# SOUND_ENABLE_SOUNDCARD_INPUT: If an input source is detected, loop it as a plugin into balena-sound.input

# Audio routing: route intermediate balena-sound input/output sinks
echo "Setting audio routing rules. Note that this can be changed after startup."
reset_sound_config
route_input_sink "$MODE"
route_output_sink
if [[ -n "$SOUND_ENABLE_SOUNDCARD_INPUT" ]]; then
  route_input_source
fi

exec pulseaudio --file /etc/pulse/balena-sound.pa