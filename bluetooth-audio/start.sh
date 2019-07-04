#!/usr/bin/env bash

if [[ -z "$BLUETOOTH_DEVICE_NAME" ]]; then
  BLUETOOTH_DEVICE_NAME=$(printf "balenaSound %s" $(hostname | cut -c -4))
fi

# set the discoverable timeout here
dbus-send --system --dest=org.bluez --print-reply /org/bluez/hci0 org.freedesktop.DBus.Properties.Set string:'org.bluez.Adapter1' string:'DiscoverableTimeout' variant:uint32:0

printf "\nSetting volume to 100%%\n"
amixer sset PCM,0 100% > /dev/null &

service bluetooth restart
sleep 2
printf "discoverable on\npairable on\nexit\n" | bluetoothctl

/usr/src/bluetooth-agent &

sleep 2
rm -rf /var/run/bluealsa/
/usr/bin/bluealsa -i hci0 -p a2dp-sink &

hciconfig hci0 up
hciconfig hci0 name "$BLUETOOTH_DEVICE_NAME"

sleep 2
/usr/bin/bluealsa-aplay --pcm-buffer-time=1000000 00:00:00:00:00:00
