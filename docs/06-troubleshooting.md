# Troubleshooting

## My DAC isn't working

If you want to use your DAC with balena you have to follow this guide: [Click Me!](https://landr-balenalabs-repo-balena-sound-preview-landr.netlify.com/docs/dac-configuration/#configure-your-device-for-the-dac)

If your DAC is not in the list can you ask us [in a issue](https://github.com/balenalabs/balena-sound/issues/new). We will then try to find the correct config for your DAC and add it to the list.

## Missing RTP Packet error
In some cases does the Pi give you errors saying there are RTP Packets missing.
There are many reasons for this. And many possible solutions:

### Bluetooth Dongle
In some cases a **external bluetooth dongle** resolved the issue: https://forums.balena.io/t/music-will-skip-and-or-pause-using-balena-sound/34260/15?u=alexprogrammerde

### Other PSU
The **PSU** can cause issues as described by @MatthewCroughan here: https://github.com/balenalabs/balena-sound/issues/62#issuecomment-605265537
We always recommend using the **original Raspberry Pi power supplys**.

### Install older OS
@mabli solved this issue with installing **balenaOS 2.38.0+rev1 production**: https://github.com/balenalabs/balena-sound/issues/47#issuecomment-543047605

### Reinstall alsa-utils
@Cyclone47 solved the issue with **reinstalling alsa-utils** (In the bluetooth-audio container which is available in the cloud dashboard): https://github.com/balenalabs/balena-sound/issues/106#issuecomment-585258034

### Unset DEVICE_NAME
It did work out for @hifipi in the forums to just **unset the DEVICE_NAME variable**: https://forums.balena.io/t/balenasound-blueooth-audio-on-raspberry-pi-3-sound-skipping-dropping/40894/37?u=alexprogrammerde

**Note:** `BLUETOOTH_DEVICE_NAME` was renamed to `DEVICE_NAME`

### Two devices are playing music at the same time
@AlexProgrammerDE recognised that if **two connected devices play at the same time** music it will cause this errors: https://github.com/balenalabs/balena-sound/issues/24#issuecomment-611963953

## USB Soundcard
Not every Soundcard is the same, so you must do other things **depending on your card**. Here are some guides:

* https://github.com/balenalabs/balena-sound/issues/9#issuecomment-513283993 
* https://github.com/balenalabs/balena-sound/issues/9#issuecomment-544730189

## Multiroom is not running
We **deactivate the multiroom service on some devices**. You can see the list here: [Click Me!](https://github.com/balenalabs/balena-sound/blob/master/DeviceSupport.md)

## I have no HDMI output on RPI 4
@zchbndcc9 resolved this issue with setting `RESIN_HOST_CONFIG_hdmi_mode` to `2`: https://github.com/balenalabs/balena-sound/issues/79#issuecomment-583712988

## Your issue is not here?
We have always a ear for you. You can report your [issue on github](https://github.com/balenalabs/balena-sound/issues/new)
