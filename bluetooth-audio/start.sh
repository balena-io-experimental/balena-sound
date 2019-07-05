#!/usr/bin/env bash

if [[ -z "$BLUETOOTH_DEVICE_NAME" ]]; then
  BLUETOOTH_DEVICE_NAME=$(printf "balenaSound %s" $(hostname | cut -c -4))
fi

# Set the discoverable timeout here
dbus-send --system --dest=org.bluez /org/bluez/hci0 org.freedesktop.DBus.Properties.Set string:'org.bluez.Adapter1' string:'DiscoverableTimeout' variant:uint32:0

printf "Setting volume to 100%%\n"
amixer sset PCM,0 100% > /dev/null &

printf "Restarting bluetooth service\n"
service bluetooth restart > /dev/null
sleep 2

# Redirect stdout to null, because it prints the old BT device name, which
# can be confusing and it also hides those commands from the logs as well.
printf "discoverable on\npairable on\nexit\n" | bluetoothctl > /dev/null

/usr/src/bluetooth-agent &

sleep 2
rm -rf /var/run/bluealsa/
/usr/bin/bluealsa -i hci0 -p a2dp-sink &

hciconfig hci0 up
hciconfig hci0 name "$BLUETOOTH_DEVICE_NAME"

sleep 2
printf "Device is discoverable as \"%s\"\n" "$BLUETOOTH_DEVICE_NAME"
/usr/bin/bluealsa-aplay --pcm-buffer-time=1000000 00:00:00:00:00:00
