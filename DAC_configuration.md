# DAC Configuration

If you are using a DAC board, you will need to make a couple of changes to the device configuration in the balenaCloud dashboard.

* Disable the on-board audio by editing the existing `RESIN_HOST_CONFIG_dtparam` variable to set `”audio=off”`.
* Add an additional custom configuration variable called `BALENA_HOST_CONFIG_dtoverlay`. The value of this will depend on your DAC board.
* Cycle the power by unplugging your pi.

![DAC Configuration](images/dac-vars.png)

## BALENA_HOST_CONFIG_dtoverlay Values

Please add the configuration values that work for your DAC to the table below.


| DAC Name               | BALENA_HOST_CONFIG_dtoverlay          | Working
|------------------------|---------------------------------------|----------
| [Suptronics X400][1]   | iqaudio-dacplus                       | [With issues][5]
| [Pimoroni pHAT DAC][2] | hifiberry-dac                         | Yes
| [Justboom DAC HAT][3]  | justboom-dac                          | Yes
| [Justboom Digi HAT][17]  | justboom-digi                          | Yes
| [Pisound][4]           | pisound                               | Yes
| [Hifiberry DAC+][6]    | hifiberry-dacplus                     | [Yes][7]
| [InnoMaker][8]         | allo-boss-dac-pcm512x-audio           | [Yes][9]
| [miniBoss DAC][10]     | allo-boss-dac-pcm512x-audio           | Yes
| [PiFi Digi+][11]       | hifiberry-digi                        | Yes
| [Pimoroni Pirate Audio][12] | hifiberry-dac                    | Yes
| [IQaudIO Pi-DAC+][13]  | iqaudio-dacplus                       | Yes
| [Hifiberry AMP2][14]   | hifiberry-dacplus                     | Yes
| [Hifiberry DAC+ Light][15] | hifiberry-dac                     | Yes
| [Hifiberry DAC Zero][16]   | hifiberry-dac                     | Yes

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
[16]: https://www.hifiberry.com/shop/boards/hifiberry-dac-zero/
[17]: https://uk.pi-supply.com/products/justboom-digi-hat
