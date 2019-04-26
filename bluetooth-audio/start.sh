#!/bin/bash
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
hciconfig hci0 name balenaSound
hciconfig hci0 class 0x200414
echo -e 'discoverable on\npairable on\nexit\n' | bluetoothctl
sleep 2

/usr/src/bluetooth-agent &

sleep 2
rm -rf /var/run/bluealsa/
/usr/bin/bluealsa -i hci0 -p a2dp-sink &

sleep 2
/usr/bin/bluealsa-aplay --pcm-buffer-time=250000 00:00:00:00:00:00
