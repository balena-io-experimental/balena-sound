# DAC Configuration

If you are using a DAC board, you will need to make a couple of changes to the device configuration in the balenaCloud dashboard.

* Disable the on-board audio by editing the existing `RESIN_HOST_CONFIG_dtparam` variable to set `”audio=off”`.
* Add an additional custom configuration variable called `BALENA_HOST_CONFIG_dtoverlay`. The value of this will depend on your DAC board.
* Cycle the power by unplugging your pi.

![DAC Configuration](images/dac-vars.png)

## BALENA_HOST_CONFIG_dtoverlay Values

Please add the configuration values that work for your DAC to the table below.

| DAC Name             | BALENA_HOST_CONFIG_dtoverlay          |
|----------------------|---------------------------------------|
| [Suptronics X400][1] | "iqaudio-dacplus, 24db_digital_gain " |
|                      | hifiberry-dac                         |
|                      |                                       |


[1]: http://www.suptronics.com/Xseries/x400.html
