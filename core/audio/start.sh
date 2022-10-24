#!/bin/bash
set -e

# PulseAudio configuration files for balena-sound
CONFIG_TEMPLATE=/usr/src/balena-sound.pa
CONFIG_FILE=/etc/pulse/default.pa.d/01-balenasound.pa

# Set loopback module latency
function set_loopback_latency() {
  local LOOPBACK="$1"
  local LATENCY="$2"
  
  sed -i "s/%$LOOPBACK%/$LATENCY/" "$CONFIG_FILE"
}

# Route any existing source to the input router ("balena-sound.input")
function route_input_source() {
  local INPUT_DEVICE=$(arecord -l | awk '/card [0-9]:/ { print $3 }')

  if [[ -n "$INPUT_DEVICE" ]]; then
    local INPUT_DEVICE_FULLNAME="alsa_input.$INPUT_DEVICE.analog-stereo"
    echo "Routing audio from '$INPUT_DEVICE_FULLNAME' into 'balena-sound.input sink'"
    echo -e "\nload-module module-loopback source=$INPUT_DEVICE_FULLNAME sink=balena-sound.input" >> "$CONFIG_FILE"
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
  sed -i "s/%OUTPUT_SINK%/sink=$OUTPUT/" "$CONFIG_FILE"
  echo "Routing 'balena-sound.output' to '$OUTPUT'."
}

function reset_sound_config() {
  if [[ -f "$CONFIG_FILE" ]]; then
    rm "$CONFIG_FILE"
  fi 
  cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"
}

# Get latency values
SOUND_INPUT_LATENCY=${SOUND_INPUT_LATENCY:-200}
SOUND_OUPUT_LATENCY=${SOUND_OUTPUT_LATENCY:-200}

# Audio routing: route intermediate balena-sound input/output sinks
echo "Setting audio routing rules..."
reset_sound_config
route_output_sink
set_loopback_latency "INPUT_LATENCY" "$SOUND_INPUT_LATENCY"
set_loopback_latency "OUTPUT_LATENCY" "$SOUND_OUPUT_LATENCY"
if [[ -n "$SOUND_ENABLE_SOUNDCARD_INPUT" ]]; then
  route_input_source
fi

exec pulseaudio