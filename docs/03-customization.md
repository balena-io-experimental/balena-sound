# Customization

Some features of balenaSound can be configured by using environment variables. Depending on how you set them they will apply to all your devices, a specific device or a specific service. Regardless of what you want, they can be set using the balena dashboard:

| Environment variable type | Scope | Instructions |
| ------ | ------ | ------ |
| Fleet-wide environment variable | all devices, all services | navigate to dashboard -> your app -> Environment variables |
| Fleet-wide service variable | all devices, specific service | navigate to dashboard -> your app -> Service variables |
| Device environment variable | specific device, all services | navigate to dashboard -> your app -> your device -> Device variables |
| Device service variable | specific device, specific service | navigate to dashboard -> your app -> your device -> Device service variables |

![Setting the device name](https://raw.githubusercontent.com/balenalabs/balena-sound/master/docs/images/env-vars.png)

You can read more about environment variables [here](https://www.balena.io/docs/learn/manage/serv-vars/#fleet-environment-and-service-variables).

## General

The following environment variables apply to balenaSound in general, modifying its behavior across the board:

| Environment variable | Description | Options | Default |
| ------ | ------ | ------ | ------ |
| SOUND_VOLUME | Output volume level at startup. | 0 - 100, integer value without the `%` symbol. | 75 |
| SOUND_DEVICE_NAME | Device name to be advertised by plugins (AirPlay device list, Spotify Connect and UPnP). | Any valid string. | `balenaSound <plugin> <xxxx>`, where:<br>- `<plugin>` is `Spotify, AirPlay, UPnP`<br>- `<xxxx>` the first 4 chars of the device UUID. |
| AUDIO_OUTPUT | Select the default audio output interface. See [audio block](https://github.com/balenablocks/audio/blob/master/README.md#environment-variables). | For all device types: <br>- `AUTO`: Automatic detection. Priority is `USB > DAC > HEADPHONES > HDMI`<br>- `DAC`: Force default output to be an attached GPIO based DAC<br><br> For Raspberry Pi devices: <br>- `RPI_AUTO`: Official BCM2835 automatic audio switching as described [here](https://www.raspberrypi.org/documentation/configuration/audio-config.md) <br>- `RPI_HEADPHONES`: 3.5mm audio jack <br>- `RPI_HDMI0`: Main HDMI port <br>- `RPI_HDMI1`: Secondary HDMI port (only Raspberry Pi 4) <br><br> For Intel NUC: <br>- NUCs have automatic output detection and switching. If you plug both the HDMI and the 3.5mm audio jack it will use the latter. | `AUTO` |
| SOUND_INPUT_LATENCY | Input loopback latency in milliseconds. Useful when experiencing frequent audio stuttering due to underruns. Note that this is only a friendly request, the actual latency might be higher. | 1 - 2000. | 200 |
| SOUND_OUTPUT_LATENCY | Output loopback latency in milliseconds. Note that this is only a friendly request, the actual latency might be higher. | 1 - 2000. | 200 |
| SOUND_SUPERVISOR_PORT | Web port that is used for serving API and UI by sound supervisor. | Any valid port number | 80 |


## Multi-room

These options only have an effect on multi-room behavior:

| Environment variable    | Description  | Options  | Default |
| --- | --- | --- | --- |
| SOUND_MULTIROOM_MASTER  | Force multi-room to use the specified IP address as the multi-room `master` device. This can't be changed unless the variable is removed.                  | An IPv4 formatted IP address. Example: `192.168.1.10` | ---     |
| SOUND_MULTIROOM_LATENCY | Set multi-room client latency. Usually used to compensate for latency that speaker hardware might introduce (some Hi-Fi systems add a noticeable latency). | Time in milliseconds. Example: `300`                  | ---     |
| SOUND_MULTIROOM_POLL_INTERVAL | Set how often multi-room devices sync up across the fleet. | Time in seconds. Example: `120`                                                    | `60` |
| SOUND_MULTIROOM_DISALLOW_UPDATES | Prevent a device to update it's multi-room `master` based on fleet activity. | Boolean. `true` / `false`                                                    | `false` |
| SOUND_MULTIROOM_DISABLE | Disables multiroom services. This prevents the device from automatically upgrading from standalone into multi-room mode. | Boolean. `true` / `false`                                                    | `false` |

## Plugins

The following environment variables control various aspects of each plugin behavior:

| Environment variable | Description | Options | Defaults |
| --- | --- | --- | --- |
| SOUND_DISABLE_< PLUGIN > where `<PLUGIN>` is the plugin name. See description. | Disable the selected plugin. Useful when you don't want to use a particular plugin. There is one variable per plugin: <br>- `SOUND_DISABLE_SPOTIFY`<br>- `SOUND_DISABLE_AIRPLAY`<br>- `SOUND_DISABLE_BLUETOOTH` | Plugin will be disabled if the variable exists regardless of its value. | --- |
| SOUND_ENABLE_SOUNDCARD_INPUT | If your soundcard has inputs you can enable soundcard input by setting this variable. Sound coming in through the audio card will be treated as a new plugin/audio source.<br><br>This feature is still experimental! | Plugin will be enabled if the variable exists regardless of its value. | --- |
| SOUND_SPOTIFY_USERNAME | Your Spotify login username. Note: most Spotify clients on phones will authenticate via zeroconf so this is not usually required. | --- | --- |
| SOUND_SPOTIFY_PASSWORD | Your Spotify login password. Note: most Spotify clients on phones will authenticate via zeroconf so this is not usually required. | --- | --- |
| SOUND_SPOTIFY_DISABLE_NORMALISATION | Disable volume normalization in Spotify. | Disabled if the variable exists regardless of its value. | --- |
| SOUND_SPOTIFY_ENABLE_CACHE | Enable the audio cache in Spotify. Note that over time the cache can take up large amounts of disk space. | Enabled if the variable exists regardless of its value. | --- |
| SOUND_SPOTIFY_BITRATE | Spotify playback bitrate. | Bitrate in kbps: `96`, `160` or `320` | 160 |
