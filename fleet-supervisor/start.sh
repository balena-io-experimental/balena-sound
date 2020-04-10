#!/usr/bin/env bash

# Start fleet supervisor if multi room is enabled
if [[ -z $DISABLE_MULTI_ROOM ]]; then
  # Wait for resin_supervisor to start up
  # We need this because depends_on: resin_supervisor is not supported
  while ! curl -s -X GET --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/ping?apikey=$BALENA_SUPERVISOR_API_KEY"; do sleep 1; done

  # Start fleet supervisor
  cd /usr/src/
  npm start
else
  echo "Multi-room audio is disabled, not starting fleet supervisor."
  exit 0
fi

