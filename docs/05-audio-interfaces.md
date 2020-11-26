# Audio interfaces

If you want to upgrade the sound quality of your balenaSound devices, or if your board has no onboard soundcard, you'll probably want to add an external soundcard. Generally these come in two flavors: **USB soundcards** or **DAC boards**. Both alternatives are widely supported in balenaSound.

Checkout the [customization](../docs/customization#general) section to learn how to select which audio interface to use. For a detailed and up to date list of what interfaces are supported on each device check out the audio block [documentation](https://github.com/balenablocks/audio#supported-devices) section.

As a general rule of thumb, onboard and USB soundcards should work out of the box without any configuration, and DACs usually require setting a `dtoverlay`. Read on to learn more about the alternatives. If for any reason you can't get your soundcard to work, feel free to [contact us](../docs/support#contact-us) and we'll gladly help out.

## Onboard

While most boards have built-in soundcards it's well known that the quality you can get from them is not the greatest. For the Raspberry Pi family for example, the Pi Foundation does an excellent job at keeping the cost of their boards down, but that comes with some compromises with audio being one of them. The [audio circuitry](https://hackaday.com/2018/07/13/behind-the-pin-how-the-raspberry-pi-gets-its-audio/) does an OK job, but it's nothing stellar. Onboard audiocards don't require any configuration.

## USB Soundcards

USB soundcards are also supported without any special configuration needed. Just make sure you power cycle your device after plugging in the soundcard and you should be good to go.

## DAC boards

### Configuration

To get a DAC board to work with balenaSound you will need to enable its corresponding Device Tree Overlay. Thankfully balenaCloud makes this very easy to do.

In the balenaCloud dashboard:

* Click on the specific device within the application and select `Device configuration` in the left-side menu.
* Add an additional custom configuration variable called `BALENA_HOST_CONFIG_dtoverlay`. The value of this will depend on your DAC board (see table below).
* Cycle the power by unplugging your pi.

![DAC Configuration](https://raw.githubusercontent.com/balenalabs/balena-sound/master/docs/images/dac-vars.png)

If you're using multiple devices with multiple DACs for multi-room audio, you'll want to do this process per unique device that is using a DAC. Do not set this variable fleet-wide as it will affect every device within your application.

### dtoverlay values

These are the DACs that are known to work with balenaSound. If your DAC is not on the list [let us know](../docs/support#contact-us), it's usually very simple to add support for new DACs:

| DAC Name                      | BALENA_HOST_CONFIG_dtoverlay          | Working
|-------------------------------|---------------------------------------|----------
| [Suptronics X400][1]          | iqaudio-dacplus                       | [With issues][5]
| [Pimoroni Pirate Audio][12]   | hifiberry-dac                         | Yes
| [Pimoroni pHAT DAC][2]        | hifiberry-dac                         | Yes
| [Justboom DAC HAT][3]         | justboom-dac                          | Yes
| [Justboom Digi HAT][25]       | justboom-digi                         | Yes
| [Pisound][4]                  | pisound                               | Yes
| [InnoMaker][8]                | allo-boss-dac-pcm512x-audio           | [Yes][9]
| [Boss DAC v1.2][29]           | allo-boss-dac-pcm512x-audio           | Yes
| [miniBoss DAC][10]            | allo-boss-dac-pcm512x-audio           | Yes
| [PiFi Digi+][11]              | hifiberry-digi                        | Yes
| [IQaudIO Pi-DAC+][13]         | iqaudio-dacplus                       | Yes
| [Hifiberry Amp2][14]          | hifiberry-dacplus                     | Yes
| [Hifiberry DAC+][6]           | hifiberry-dacplus                     | [Yes][7]
| [Hifiberry DAC+ Light][15]    | hifiberry-dac                         | Yes
| [Hifiberry DAC+ Standard][16] | hifiberry-dacplus                     | Yes
| [Hifiberry DAC+ Pro][17]      | hifiberry-dacplus                     | Yes
| [Hifiberry DAC Zero][18]      | hifiberry-dac                         | Yes
| [Hifiberry Amp+][19]          | hifiberry-amp                         | Yes
| [Hifiberry Digi][20]          | hifiberry-digi                        | Yes
| [Hifiberry Digi+][21]         | hifiberry-digi                        | Yes
| [Hifiberry Beocreate][22]     | hifiberry-dac                         | Yes
| [Hifiberry DAC+ DSP][23]      | hifiberry-dac                         | Yes
| [Hifiberry MiniAmp][24]       | hifiberry-dac                         | Yes
| [Hifiberry DAC2 HD][27]       | hifiberry-dacplushd                   | Yes
| [Adafruit I2S Audio Bonnet][26]| "hifiberry-dac","i2s-mmap"           | Yes
| [Adafruit MAX98357 I2S Class-D Mono Amp][28]| "hifiberry-dac”,"i2s-mmap" | Yes

[1]: http://www.suptronics.com/Xseries/x400.html
[2]: https://shop.pimoroni.com/products/phat-dac
[3]: https://uk.pi-supply.com/products/justboom-dac-hat
[4]: https://blokas.io/pisound/
[5]: https://forums.balena.io/t/regarding-dac-installation-on-balenasound-project/45568/27
[6]: https://www.hifiberry.com/products/dacplus/
[7]: https://forums.balena.io/t/no-sound-from-dac/61343/5
[8]: http://www.inno-maker.com/product/hifi-dac-hat/
[9]: https://github.com/balenalabs/balena-sound/pull/98
[10]: https://allo.com/sparky/miniboss-rpi-zero.html
[11]: http://www.kumantech.com/kuman-sc07-raspberry-pi-hifi-digi-digital-sound-card-i2s-spdif-optical-fiber-for-raspberry-pi-3-2-model-b-b-sc07_p0041.html
[12]: https://shop.pimoroni.com/collections/pirate-audio
[13]: http://iqaudio.co.uk/hats/8-pi-dac.html
[14]: https://www.hifiberry.com/shop/boards/hifiberry-amp2/
[15]: https://www.hifiberry.com/shop/boards/hifiberry-dac-light/
[16]: https://www.hifiberry.com/shop/boards/hifiberry-dacplus-rca-version/
[17]: https://www.hifiberry.com/shop/boards/hifiberry-dac-pro/
[18]: https://www.hifiberry.com/shop/boards/hifiberry-dac-zero/
[19]: https://www.hifiberry.com/products/ampplus/
[20]: https://www.hifiberry.com/products/digi/
[21]: https://www.hifiberry.com/products/digiplus/
[22]: https://www.hifiberry.com/beocreate/
[23]: https://www.hifiberry.com/shop/boards/hifiberry-dac-dsp/
[24]: https://www.hifiberry.com/shop/boards/miniamp/
[25]: https://uk.pi-supply.com/products/justboom-digi-hat
[26]: https://www.adafruit.com/product/4037
[27]: https://www.hifiberry.com/shop/boards/hifiberry-dac2-hd/
[28]: https://learn.adafruit.com/adafruit-max98357-i2s-class-d-mono-amp
[29]: https://allo.com/sparky/boss-dac.html
