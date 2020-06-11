# Usage

After the application has pushed and the device has downloaded the latest changes, you're ready to go! 
Before starting, connect the audio output of your Pi to the AUX input on your Hi-Fi or speakers. You can also use the HDMI port for digital audio output.

To connect to your balenaSound device:
* If using Bluetooth: search for your device on your phone or laptop and pair.
* If using Airplay: select the balenaSound device from your audio output options.
* If using Spotify Connect: open Spotify and choose the balenaSound device as an alternate output.
* If using UPnP: select the balenaSound device from your UPnP app like [BubbleUPnP](https://play.google.com/store/apps/details?id=com.bubblesoft.android.bubbleupnp) (Android) or [JuP&P](https://apps.apple.com/app/jup-p-upnp-player-und-fernbedienung/id1069722311) (IOS).
* The `balenaSound xxxx` name is used by default, where `xxxx` will be the first 4 characters of the device ID in the balenaCloud dashboard.

If you are running in multi-room mode, the device that starts the stream will configure itself as the master and will broadcast a message to all other devices within your balenaCloud application to get them in sync. 

**Note:** It can take a few seconds for the system to autoconfigure the first time you stream.

Let the music play!