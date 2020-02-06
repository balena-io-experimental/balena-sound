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
| [Pisound][4]           | pisound                               | Yes
| [Hifiberry DAC+][6]    | hifiberry-dacplus                     | [Yes][7]


[1]: http://www.suptronics.com/Xseries/x400.html
[2]: https://shop.pimoroni.com/products/phat-dac
[3]: https://uk.pi-supply.com/products/justboom-dac-hat
[4]: https://blokas.io/pisound/
[5]: https://forums.balena.io/t/regarding-dac-installation-on-balenasound-project/45568/27
[6]: https://www.hifiberry.com/products/dacplus/
[7]: https://forums.balena.io/t/no-sound-from-dac/61343/5