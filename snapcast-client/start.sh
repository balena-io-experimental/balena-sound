#!/usr/bin/env bash

# Start snapclient if multi room is enabled
if [[ -z $DISABLE_MULTI_ROOM ]]; then
  # Wait for fleet-supervisor to start up
  # We need this because fleet-supervisor depends on resin_supervisor, which has no support for depends_on
  while ! curl -s "http://localhost:3000"; do sleep 1; done

  # Select alternate soundcard here
  if [[ ${SOUNDCARD_SELECT:-0} -gt 0 ]]; then
    cat > /root/.asoundrc << EOF
pcm.!default {
  type hw
  card ${SOUNDCARD_SELECT}
}

ctl.!default {
  type hw           
  card ${SOUNDCARD_SELECT}
}
EOF
  echo "Selected soundcard ${SOUNDCARD_SELECT}"
  fi

  # Add latency if defined to compensate for speaker hardware sync issues
  if [[ -n $DEVICE_LATENCY ]]; then
    LATENCY="--latency $DEVICE_LATENCY"
  fi

  # Start snapclient
  SNAPCAST_SERVER=$(curl --silent http://localhost:3000)
  echo -e "Starting snapclient...\nTarget snapcast server: $SNAPCAST_SERVER"
  /usr/bin/snapclient -h $SNAPCAST_SERVER $LATENCY
else
  echo "Multi-room audio is disabled, not starting snapclient."
  exit 0
fi
