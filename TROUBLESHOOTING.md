# Troubleshooting
#### We are collecting here some solutions for known issues

### My DAC works not with balena

If you want to use your DAC with balena you have to follow this guide: [Click Me!](https://github.com/balenalabs/balena-sound/blob/master/DAC_configuration.md#dac-configuration)

If your DAC is not in the list can you ask us [in a issue](https://github.com/balenalabs/balena-sound/issues). We will then try to find the correct config for your DAC and add it to the list.

### Missing RTP Packet / Sound cuts out 
In some cases does the Pi give you errors saying there are RTP Packets missing.
There are many reasons for this. And many possible solutions:
##### Bluetooth Dongle
In some cases a external bluetooth dongle resolved the issue: https://forums.balena.io/t/music-will-skip-and-or-pause-using-balena-sound/34260/15?u=alexprogrammerde
##### Other PSU
The PSU can cause issues as described by @MatthewCroughan here: https://github.com/balenalabs/balena-sound/issues/62#issuecomment-605265537
We always recommend using the original Raspberry Pi power supply.
##### Install older OS
@mabli solved this issue with installing balenaOS 2.38.0+rev1 production: https://github.com/balenalabs/balena-sound/issues/47#issuecomment-543047605
##### Reinstall alsa-utils
@Cyclone47 solved the issue with reinstalling alsa-utils (In the bluetooth-audio container which is aviable at the cloud dashboard): https://github.com/balenalabs/balena-sound/issues/106#issuecomment-585258034
##### Unset DEVICE_NAME
It did work out for hifipi in the forums to just unset the DEVICE_NAME variable: https://forums.balena.io/t/balenasound-blueooth-audio-on-raspberry-pi-3-sound-skipping-dropping/40894/37?u=alexprogrammerde
**Note:** `BLUETOOTH_DEVICE_NAME` was renamed to `DEVICE_NAME`

### USB Soundcard
Not every Soundcard is the same, so you must do other things depending on your card. Here are some guides:

* https://github.com/balenalabs/balena-sound/issues/9#issuecomment-513283993 
* https://github.com/balenalabs/balena-sound/issues/9#issuecomment-544730189

### On my device is multiroom not running
We deactivate the multiroom service on some devices. You can see the list here: [Click Me!](https://github.com/balenalabs/balena-sound/blob/master/DeviceSupport.md)
