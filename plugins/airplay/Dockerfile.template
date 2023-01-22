FROM mikebrady/shairport-sync:4.1.1 as shairport
WORKDIR /usr/src

ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

# DL4006: https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/sh", "-eo", "pipefail", "-c"]

# shairport-sync docker image doesn't include pulseaudio support so we use ALSA bridge
ENV PULSE_SERVER=tcp:localhost:4317
RUN apk add --no-cache supervisor curl~=7 && \
  curl -skL https://raw.githubusercontent.com/balena-labs-projects/audio/master/scripts/alsa-bridge/alpine-setup.sh | sh \
  && apk del curl

COPY start.sh /usr/src/
COPY supervisor.conf /usr/src/supervisor.conf

# shairport-sync image entrypoint starts dbus and avahi daemons that we don't need
ENTRYPOINT []
CMD ["supervisord","-c","/usr/src/supervisor.conf"]
