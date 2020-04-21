# DAC Configuration

While most Raspberry Pi boards come with an onboard sound card it is well known that the quality you can get from them is not the greatest. The Pi Foundation makes an excelent job at keeping the cost of their bords down, but that comes with some compromises, audio being one of them: the [audio circuitry](https://hackaday.com/2018/07/13/behind-the-pin-how-the-raspberry-pi-gets-its-audio/) does an OK job but it's nothing stellar.

If you want to upgrade the sound quality of your balenaSound devices (or if you are using a board that does not have onboard sound card such as the Raspberry Pi Zero) you will need to add a DAC board (Digital Audio Converter) to your project.

### Configure your device
To get a DAC board to work with balenaSound, you will need to make a couple of changes to the device configuration in the balenaCloud dashboard:

* Disable the on-board audio by editing the existing ```RESIN_HOST_CONFIG_dtparam``` variable to set `”audio=off”`.
* Add an additional custom configuration variable called `BALENA_HOST_CONFIG_dtoverlay`. The value of this will depend on your DAC board (see table below).
* Cycle the power by unplugging your pi.

![DAC Configuration](https://raw.githubusercontent.com/balenalabs/balena-sound/master/images/dac-vars.png)

### dtoverlay Values

These are the DACs that are known to work with balenaSound. If your DAC is not on the list let us know! It's usually very simple to add support for new DACs, feel free to open a [PR](https://github.com/balenalabs/balena-sound/compare/) or [issue](https://github.com/balenalabs/balena-sound/issues/new) on our repository.

| DAC Name                      | BALENA_HOST_CONFIG_dtoverlay          | Working
|-------------------------------|---------------------------------------|----------
| [Suptronics X400][1]          | iqaudio-dacplus                       | [With issues][5]
| [Pimoroni Pirate Audio][12]   | hifiberry-dac                         | Yes
| [Pimoroni pHAT DAC][2]        | hifiberry-dac                         | Yes
| [Justboom DAC HAT][3]         | justboom-dac                          | Yes
| [Justboom Digi HAT][25]       | justboom-digi                         | Yes
| [Pisound][4]                  | pisound                               | Yes
| [InnoMaker][8]                | allo-boss-dac-pcm512x-audio           | [Yes][9]
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
