# Usage

After your device finishes downloading the application, you should be ready to go! 
Before starting make sure to connect the audio output of your device to your Hi-Fi or speaker system. Remember we support multiple [audio interfaces](../audio-interfaces) if you are interested in improving the audio quality of your setup be sure to check it out.

To connect to your balenaSound device:
* If using Bluetooth: search for your device on your phone or laptop and pair.
* If using Airplay: select the balenaSound device from your audio output options.
* If using Spotify Connect: open Spotify and choose the balenaSound device as an alternate output.
* If using UPnP: select the balenaSound device from your UPnP app like [BubbleUPnP](https://play.google.com/store/apps/details?id=com.bubblesoft.android.bubbleupnp) (Android) or [JuP&P](https://apps.apple.com/app/jup-p-upnp-player-und-fernbedienung/id1069722311) (IOS).

The `balenaSound <plugin> xxxx` name is used by default, where `xxxx` will be the first 4 characters of the device UUID in the balenaCloud dashboard.

Let the music play!

## Modes of operation

balenaSound supports multiple modes of operation described below:

- Multi-room mode
- Multi-room client mode
- Standalone

**Note:** Multi-room mode is the default mode for most (but not all!) device types. You can read more about default modes [here](../device-support).

### Multi-room mode

Multi-room mode allows you to play perfectly synchronized audio on multiple devices, it turns balenaSound into a "Sonos-like" multi-room solution. It doesn't matter wether you have 2 or 100 devices, you only need them to be part of the same local network.

When in multi-room mode devices can take one of two roles: 
- `master`: the device acting as the audio source
- `client`: any number of devices playing back the audio being sent over by the `master``

Designing a `master` device is easy and requires no configuration. Whenever you start streaming to any device in multi-room mode it will autoconfigure itself to be the `master` device and will broadcast a message to all other devices within your local network to get them in sync. Note that it can take a few seconds for the system to autoconfigure the first time you stream. 
You can always change the `master` by streaming to a different device.

It's a good idea to use the most powerful device on your fleet as the designated `master` as it does take up more resources. For example, if your setup consists of a Raspberry Pi 4 and a couple of Raspberry Pi 2, then using the Pi 4 as the `master` is the better option.


### Multi-room client mode

When a device is in multi-room client mode it can only be used as a multi-room `client`. The device will only play audio coming from a `master` device so you'll need at least another device in your application. 

This mode is great for performance constrained devices as plugin services (Spotify, AirPlay, etc) won't be running and consuming CPU cycles. It's also a great choice if you usually stream to the same `master` device and don't want to have every device show up when pairing bluetooth for example.


### Standalone

Standalone is the original balenaSound mode (pre version 2.0). In this mode your device won't run any of the multi-room services, it will run independently and won't be aware of other devices in your network/application.

Use this mode when you have only one device in your fleet, or if you want to have multiple independent devices.

## Plugin system

balenaSound has been re-designed to easily allow integration with audio streaming sources. These are the sources we currently support and the projects that make it possible:

| Plugin | Library/Project |
| ------ | ------ |
| Spotify | [raspotify](https://github.com/dtcooper/raspotify/). Spotify Connect only works with Spotify Premium accounts. If you have a Spotify Premium account, you can stream locally without any configuration. If you want to use Spotify Connect over the internet, you'll need to provide your Spotify credentials. See [customization](../customization) section for details. |
| AirPlay | [shairport-sync](https://github.com/mikebrady/shairport-sync/) |
| UPnP | [gmrenderer-resurrect](https://github.com/hzeller/gmrender-resurrect) |
| Bluetooth | balena [bluetooth](https://github.com/balena-io-playground/bluetooth-primitive/) and [audio](https://github.com/balenablocks/audio) blocks |
| Soundcard input | Experimental support through the balena [audio](https://github.com/balenablocks/audio) block |

If your desired audio source is not supported feel free to [reach out](../support#contact-us) and leave us a comment. We've also considerably simplyfied the process of adding new plugins, so [PR's are welcome](../../contributing) too!

## Audio interfaces

balenaSound supports all audio interfaces present on our [supported devices](../device-support) be it 3.5mm audio jack, HDMI, I2C DAC's or USB soundcards. We rely on [balenaLabs' audio block](https://github.com/balenablocks/audio) to do the heavy lifting configuration required for this to work. 

Some audio interfaces require special configuration, you can read more about this in the [audio interfaces](../audio-interfaces) configuration section.