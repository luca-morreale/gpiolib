# gpiolib [![Build Status](https://travis-ci.org/luca-morreale/gpiolib.svg)](https://travis-ci.org/luca-morreale/gpiolib)
A simple library to interface with Raspberry Pi's GPIO written in D language

# Features
This library allows to control Raspberry Pi GPIO very easly, but it does not
provide all the functionality of available over the board, such as I2C.
For now is possible to control(read or set) directions and values of pins.

## Example

```d
import gpiolib;

void main(){
    auto gpio = new GPIO!MemoryAttuator();
    auto pin4 = gpio.createPin(4);

    pin4.outputMode();
    pin4.high();
}
```
