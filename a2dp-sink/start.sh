#!/bin/sh
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

rm -rf /var/run/bluealsa/
/usr/bin/bluealsa -i hci0 -p a2dp-sink &
/usr/bin/bluealsa-aplay --pcm-buffer-time=250000 00:00:00:00:00:00
