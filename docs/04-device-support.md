
# Device support

## Recommended

balenaSound has been developed and tested to work on the following devices:

| Device Type  |  Default mode | Standalone mode (`STANDALONE`) | Multi-room mode (`MULTI_ROOM`) | Multi-room client mode (`MULTI_ROOM_CLIENT`) |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| Raspberry Pi (v1 / Zero / Zero W)<sup>1</sup> | `STANDALONE` | ✔ | ✘ <sup>2</sup> | ✔ | 
| Raspberry Pi 2 | `STANDALONE` | ✔ | ✘ <sup>2</sup> | ✔ | 
| Raspberry Pi 3 <sup>3</sup> | `MULTI_ROOM` | ✔ | ✔ <sup>4</sup> | ✔ | 
| Raspberry Pi 4 <sup>3</sup> | `MULTI_ROOM` | ✔ | ✔ | ✔ | 
| Intel NUC | `MULTI_ROOM` | ✔ | ✔ | ✔ | 
| balenaFin<sup>1</sup> | `MULTI_ROOM` | ✔ | ✔ | ✔ | 


**Notes**
[1]: We recommend using a DAC or USB sound card for these device types. See [audio interfaces](../audio-interfaces) for more details.
[2]: Multi-room `master` functionality is disabled on Raspberry Pi 1 and 2 family devices due to performance constraints. They can however function in multi-room client mode in conjunction with another device that supports multi-room mode. Read more about modes of operation [here](../usage).

-- TODO: check if 3 and 4 are still true
[3]: Currently balenaSound can not run on balenaOS 64 bit versions, please use 32 bit alernative. See this [issue](https://github.com/balenalabs/balena-sound/issues/82) for more informaton and an up to date status.
[4]: There is a [known issue](https://github.com/raspberrypi/linux/issues/1444) with all variants of the Raspberry Pi 3 where Bluetooth and WiFi interfere with each other. This will only impact the performance of balenaSound if you use a **Pi 3 as the master server to do multi-room bluetooth streaming**, resulting in stuttering audio (Airplay and Spotify Connect will work fine, as well as all streaming methods with multi-room disabled). In this cases we recommend the use of a Raspberry Pi 4 as the `master` server or a Pi 3 with a bluetooth dongle.

## Experimental

Devices with experimental support **have been tested to work with balenaSound** though we have found compelling reasons for not including them as first class citizens of balenaSound. If you are shopping for parts we do not recommend you buy a device from this list. 

Some of the reasons we've flagged devices as experimental include:
- device requires multiple extra hardware pieces (USB dongles, adapters, etc)
- device has known bugs that prevent some features to work properly and the timeline for a fix is not clear

| Device Type  | Standalone mode (`STANDALONE`) | Multi-room mode (`MULTI_ROOM`) | Multi-room client mode (`MULTI_ROOM_CLIENT`) | Comments |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| NVIDIA Jetson Nano | ✔ | ✔ | ✔ | - Requires WiFi USB dongle (or ethernet cable)<br>- Requires Bluetooth USB dongle.<br>- No built-in audio support (see [this](https://github.com/balenablocks/audio/issues/35) bug). As a workaround, requires USB or DAC soundcard.|
| BeagleBone Black | ✔ | ✔ | ✔ |  - Requires WiFi USB dongle (or ethernet cable)<br>- Requires Bluetooth USB dongle.<br>- Requires USB sound card<br>- Requires USB hub as it has a single USB port |


