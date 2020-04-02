![](https://raw.githubusercontent.com/balena-io-projects/balena-sound/master/images/balenaSound-logo.png)

# Bluetooth, Airplay and Spotify audio streaming for any audio device

**Starter project enabling you to add multi-room audio streaming via Bluetooth, Airplay or Spotify Connect to any old speakers or Hi-Fi using just a Raspberry Pi.**

**Features**
- **Bluetooth, Airplay and Spotify Connect support**: Stream audio from your favourite music services or directly from your smartphone/computer using bluetooth.
- **Multi-room synchronous playing**: Play perfectly synchronized audio on multiple devices all over your place.


# Motivation

It's just a cool project!

## Connect

* After the application has pushed and the device has downloaded the latest changes you're ready to go!
* Connect the audio output of your Pi to the AUX input on your Hi-Fi or speakers
* The `balenaSound bluetooth/airplay/spotify xxxx` name is used by default, where `xxxx` will be the first 4 characters of the device ID in the balenaCloud dashboard.
* If using Bluetooth: search for your device on your phone or laptop and pair.
* If using Airplay: select the balenaSound device from your audio output options.
* If using Spotify Connect: open Spotify and choose the balenaSound device as an alternate output.
* Let the music play!
If you have a Spotify Premium account you can stream locally without any configuration, but if you want to use Spotify Connect over the internet you will need to provide your Spotify credentials.

To enable Spotify login you can add your username/e-mail and password, which are set with two environment variables: `SPOTIFY_LOGIN` and `SPOTIFY_PASSWORD`.  

---

This project is in active development so if you have any feature requests or issues please submit them here on GitHub. PRs are welcome, too.
