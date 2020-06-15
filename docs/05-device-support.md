
# Supported devices

balenaSound has been tested to work on the following devices:

| Device Type  | Multi-room disabled | Multi-room server | Multi-room client |
| ------------- | ------------- | ------------- | ------------- |
| Raspberry Pi (v1 / Zero / Zero W) | ✔ | ✘ <sup>1</sup> | ✔ |
| Raspberry Pi 2 | ✔ | ✘ <sup>1</sup> | <sup>2</sup> | 
| Raspberry Pi 3 <sup>3</sup> | ✔ | ✔ <sup>4</sup> | ✔ | 
| Raspberry Pi 4 <sup>3</sup> | ✔ | ✔ | ✔ | 


**Notes**
[1]: Multi-room master server functionality is disabled by default on Raspberry Pi 1 and 2 family devices due to performance constraints.
[2]: Not tested. Feel free to share your results.
[3]: Currently balenaSound can not run on balenaOS 64 bit versions, please use 32 bit alernative. See this [issue](https://github.com/balenalabs/balena-sound/issues/82) for more informaton and an up to date status.
[4]:   There is a [known issue](https://github.com/raspberrypi/linux/issues/1444) with all variants of the Raspberry Pi 3 where Bluetooth and WiFi interfere with each other. This will only impact the performance of balenaSound if you use a **Pi 3 as the master server to do multi-room bluetooth streaming**, resulting in stuttering audio (Airplay and Spotify Connect will work fine, as well as all streaming methods with multi-room disabled). In this cases we recommend the use of a Raspberry Pi 4 as the `master` server or a Pi 3 with a bluetooth dongle.

