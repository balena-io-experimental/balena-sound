#!/bin/sh
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

hciconfig hci0 name balenaSound
hciconfig hci0 class 0x200414

/usr/src/bluetooth-agent
