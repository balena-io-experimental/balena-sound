# Getting started

Getting started with balenaSound is as simple as deploying it to a [balenaCloud](https://balena.io/cloud) application; no additional configuration is required (unless you're using a DAC HAT).
We've outlined the installation steps below, if you want an in depth step by step tutorial on how to get balenaSound up and running feel free to check this blog posts:
- [Turn your old speakers or Hi-Fi into Bluetooth, Airplay and Spotify receivers with a Raspberry Pi and this step-by-step guide](https://www.balena.io/blog/turn-your-old-speakers-or-hi-fi-into-bluetooth-receivers-using-only-a-raspberry-pi/)
- [Build your own multi-room audio system with Bluetooth, Airplay, and Spotify using Raspberry Pis](https://www.balena.io/blog/diy-raspberry-pi-multi-room-audio-system/)

## Hardware required
![](https://raw.githubusercontent.com/balenalabs/balena-sound/landr-v2-poc/images/hardware.jpeg)

* Raspberry Pi 3A+/3B/3B+/4B/Zero W
* SD Card (we recommend 8GB Sandisk Extreme Pro)
* Power supply
* 3.5mm audio cable to the input on your speakers/Hi-Fi (usually 3.5mm or RCA). Alternatively you can use the HDMI port to get digital audio out.

**Notes** 
- The Raspberry Pi Zero cannot be used on it's own as it has no audio output. To use the Pi Zero you'll need to add something like the [Pimoroni pHAT DAC](https://shop.pimoroni.com/products/phat-dac) (out of stock and going to be replaced, see [#111](https://github.com/balenalabs/balena-sound/issues/111)) to go with it.
- For an extended list of device types supported please check this [link](DeviceSupport.md).


## Software required

* A download of this project (of course)
* Software to flash an SD card ([balenaEtcher](https://balena.io/etcher))
* A free [balenaCloud](https://balena.io/cloud) account
* The [balena CLI tools](https://github.com/balena-io/balena-cli/blob/master/INSTALL.md)


## Provision your device

![](https://raw.githubusercontent.com/balenalabs/balena-sound/landr-v2-poc/images/sdcard.gif)

* Sign up for or login to the [balenaCloud dashboard](https://dashboard.balena-cloud.com)
* Create an application, selecting the correct device type for your Raspberry Pi (we recommend setting the type as Raspberry Pi 1/Zero as your application will then be compatible with the Pi 1/Zero as well as all devices that were released afterward).
* Add a device to the application, enabling you to download the OS
* Flash the downloaded OS to your SD card with [balenaEtcher](https://balena.io/etcher)
* Power up the Pi and check it's online in the dashboard

## Deploy the application

* Install the [balena CLI tools](https://github.com/balena-io/balena-cli/blob/master/INSTALL.md)
* Login with `balena login`
* Download this project and from the project directory run `balena push <appName>` where `<appName>` is the name you gave your balenaCloud application in the first step.