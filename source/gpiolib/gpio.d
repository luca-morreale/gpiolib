/**
    This module proved a simple class representing an interface to create GPIO pin.

    Author: Morreale Luca
*/

module gpiolib.gpio;

import gpiolib.attuators;

/**
    This class could work with memory register(faster), or with files;
    in both ways to use it root user is needed.

    The T class must be an implementation of Attuator interface.
    To work with memory registry the class MemoryAttuator is provided,
    is also possible to work with with files just using instead FileAttuator.
*/

class GPIO(T : Attuator) {

    T attuator;

    this() {
        attuator = new T();
    }

    public Pin createPin(int gpioNumber) {
        return attuator.exportPin(gpioNumber);
    }

}
