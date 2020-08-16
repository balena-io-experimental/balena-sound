# Troubleshooting
This section provides troubleshooting guidance for a few common pitfalls users have faced when deploying balenaSound. If you are experiencing a problem that is not listed in here please feel free to reach us at our [forums](https://forums.balena.io) or open an [issue](https://github.com/balenalabs/balena-sound/issues/new) on our GitHub repository.

## Audio cuts or is very stuttery
### Description
When streaming audio via bluetooth to a Raspberry Pi 3 B/B+ that is running balenaSound, you experience the following:
- Audio output has intermittent cuts every few seconds. This can be anything from once every few seconds to multiple bursts per second.
- The `bluetooth-audio` service logs the following errors:
```
21.12.19 22:35:35 (+1100) bluetooth-audio /usr/bin/bluealsa: SBC decoding error: No such process
21.12.19 22:35:35 (+1100) bluetooth-audio /usr/bin/bluealsa: Missing RTP packet: 27632 != 27630
```

### Explanation
Stuttering issues on the Raspberry Pi 3 family are related to a known problem with the BCM43438/CYW43438 chip where Bluetooth and WiFi signals interfere with each other. Both the chip manufacturer (Cypress) and the Raspberry Pi Foundation have acknowledged this and there are several upstream open issues that address it. Unfortunately this doesn't seem to be a high priority task for them. Here are the relevant GitHub issues:
- https://github.com/raspberrypi/linux/issues/1552
- https://github.com/raspberrypi/linux/issues/2264
- https://github.com/raspberrypi/linux/issues/1444
- https://github.com/raspberrypi/linux/issues/1402
- https://github.com/Arkq/bluez-alsa/issues/60

## Known workarounds
At the moment there is no "official" solution to this problem. The following workarounds have proven to work or at least reduce the frequency of the audio cuts. Your milleage might vary depending on your use case so be sure to test them all.

#### Use a USB Bluetooth dongle
This is the official recommendation made by the Raspberry Pi Foundation. Adding a USB Bluetooth dongle to your board removes the interference problems happening at the onboard WiFi/BT chip. balenaSound will automatically detect the bluetooth dongle and configure itself to use it in place of the board's bluetooth. 

[This](https://www.amazon.com/TP-Link-Bluetooth-Receiver-Controllers-UB400/dp/B07V1SZCY6/ref=sr_1_7) dongle has been tested to work for this, but any dongle really should work.

#### Disable multi-room feature
Using multi-room has proven to make this issue a lot more frequent and noticeable; most likely due to the increased resource usage that it requires.
- If you are *not* using multi-room (you only have one device on your balenaSound fleet) you can disable it to aleviate the problem. Check our [docs](../customizations/#disable-multi-room) to find out how. 
- If you are using multi-room consider changing the `master server` from which you stream to other devices to a Raspberry Pi 4. Raspberry Pi 3's exhibit audio stuttering when working as `master server` but they work fine if you use them as `clients`. 

#### Change Power Supply Unit (PSU)
Bad quality power supply units are more likely to trigger this problem. Investing in a good power supply unit is always a good idea! 
We recommend using the [original Raspberry Pi power supply](https://www.raspberrypi.org/products/raspberry-pi-universal-power-supply/) and if not possible at least one that conforms to the power requirements described in [here](https://www.raspberrypi.org/documentation/hardware/raspberrypi/power/README.md).

Thank you [@MatthewCroughan](https://github.com/MatthewCroughan) for the torough [investigation and testing](https://github.com/balenalabs/balena-sound/issues/62#issuecomment-605265537)!

#### Rolling back to balenaOS 2.38 / Reduce Bluetooth UART baud rate
Raspberry Pi 3's before rev 1.3 have no HW flow control on the UART that controlls the Bluetooth modem. This causes occasional data loss which result in the audio stuttering problem described above. Reducing the UART baud rate to `460800` lessens the problem significantly when compared to the default value of `921600`. 

This however requires advanced knowledge and usage of balenaOS. So the advised change is to roll back to balenaOS version 2.38.0+rev1 which uses a default baud rate of `921600` but has other firmware conifiguration that avoids this problem. In order to roll back your balenaOS version you will need to re-flash your SD card and re-provision your device.

We are currently working on bringing back the configuration present in balenaOS 2.38 to the latest version so that the roll back is not necessary; you can keep track of it [here](https://github.com/balena-os/balena-raspberrypi/issues/476).


## No audio
### Description

No audio is coming out of your speaker system.

### Solution
Ensure that:
- You correctly plugged an audio or HDMI cable to your device
- You are connected to the device and streaming audio to it via any of the supported alternatives

If you are using a DAC, make sure your DAC is on the supported list [here](../dac-configuration/) and that you applied the required configuration changes. If your DAC is not on the list, please let us know by opening an [issue](https://github.com/balenalabs/balena-sound/issues/new). We will work with you to find the correct configuration and add the DAC to the supported list.

If you are using a USB soundcard, bear in mind that they are not *officially* supported by balenaSound. Some users have had positive results however not every Soundcard is the same. You can check out their progress here and please share your results whatever the outcome is:
- https://github.com/balenalabs/balena-sound/issues/9#issuecomment-513283993
- https://github.com/balenalabs/balena-sound/issues/9#issuecomment-544730189

## Multi-room devices are out of sync
### Description

When using the multi-room feature, there might be devices that are out of sync with the master server. This delay is usually a few hundred milliseconds, enough to be noticeable, and it doesn't change over time.

### Explanation
To sync audio across your fleet of balenaSound devices we use [Snapcast](https://github.com/badaix/snapcast) which has a typical deviation of less than 0.2ms. Snapcast is extremely stable so it’s not very likely that software is at fault. The most likely explanation for your devices being out of sync is due to the differences in audio processing after it goes out of the Pi and into the speakers. Every speaker is different; differences in audio circuitry and digital processing can result in a device taking a few milliseconds longer than another to actually output the audio. TV's are known for adding noticeable delays when using them as "speakers".

### Solution
Snapcast has an option that allows us to compensate for this short delays on devices. This feature however is currently not implemented on the `master` branch of balenaSound as it hasn't been toroughly tested. You can still try it out though and with enough feedback we will be merging it into the main branch.

To test:

1. Download the updated code from https://github.com/balenalabs/balena-sound/tree/snapclient-latency

2. Push the new branch to your devices using `balena push <appName>` (or using `git` if that is how you initially deployed)

3. On your balena dashboard, navigate to the **device** that you notice is behind (the one that is late or more delayed) and add a `Device environment variable` (`Device variables` on the side bar). Name the variable `DEVICE_LATENCY` and assign it a value in msec. You will need to find out the exact value for yourself, `300` (msec) is a good starting point.

4. Wait for your device to reboot, and test again. You might have to adjust the latency value a couple of times until you find one that works.

When creating the environment variable make sure you define it **only** for the device you hear is lagging behind. If you define the variable from the application screen you will most likely do it fleet-wide which defeats the purpose.

## Audio is delayed
### Description
When playing audio from any source it takes a few seconds for it to start/stop playing (usually 2-3 seconds). This is especially noticeable when streaming audio from a video source as it's not in sync with the image.

### Explanation
balenaSound uses many technologies to provide audio streaming capabilities. All these layers of software introduce a small amount of delay that in the end add up to something that can be noticeable. We understand that this means that balenaSound is not suitable for certain applications (streaming audio from video sources for instance) but we believe this is an acceptable tradeoff for all the cool features we have.

### Workarounds

There are however workarounds that you might want to take if you are willing to sacrifice some features:

- Airplay streaming has a built-in two-second delay. Using a different audio source will obviously yield better results. 
- For bluetooth streaming, you can reduce the delay at the expense of stability. You can do so by editing `bluetooth-audio/start.sh` file, you'll need to edit the `--pcm-buffer-time` value in the last line that reads: `exec /usr/bin/bluealsa-aplay --pcm-buffer-time=1000000 00:00:00:00:00:00`. You can try decresing the value and see what works best for you.
- If you are *not* using the multi-room feature you can disable it; multi-room adds the most of the perceived delay as it needs it to sync audio across devices. Check our [docs](../customizations/#disable-multi-room) to find out how to disable it. 


## Multiroom is not working
### Description
Streaming audio to a device works fine but other devices on the network don't sync to it. 

### Solution
Multi-room is not supported for all device types due to resource constraints. We deactivate the multi-room service on some devices by default. You can see the list [here](../supported-devices)

If you are using a supported device type and still can't get multi-room to work try power cycling the `master server` device. Devices might have missed the event broadcast where a device announces itself as a new `master server`, by rebooting it we force the device to send them again.

## No audio on HDMI output on Raspberry Pi 4
### Description
HDMI audio output is currently not working as intended on Raspberry Pi 4. See this [issue](https://github.com/balenalabs/balena-sound/issues/79) for details.

### Workaround
You can force HDMI audio to work by setting the device environment variable `BALENA_HOST_CONFIG_hdmi_mode` to `2`. Thanks to [@zchbndcc9](https://github.com/zchbndcc9) for finding this workaround.

## No audio when using balenaOS 64 bit on Raspberry Pi 3's
### Description
No audio coming out from either the audio jack or HDMI when using balenaOS 64 bit on a Raspberry Pi 3.

For details see:
- https://github.com/balenalabs/balena-sound/issues/82
- https://github.com/balena-io/balena-supervisor/issues/1245

### Workaround
Remove the `vc4-kms-v3d` dtoverlay setting from the `Device Configuration` section of your device.

## Become a balena poweruser

One way to improve how you use and contribute to balenaSound is to take our [masterclasses](https://www.balena.io/docs/learn/more/masterclasses/overview/). Each lesson is a self-contained, deep walkthrough on core skills to be successful with your next edge project.

Check them out at our [docs](https://www.balena.io/docs/learn/more/masterclasses/overview/). Also, reach out to us on the [Forums](https://forums.balena.io/) if you need help.