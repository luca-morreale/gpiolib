module gpiolib.modes.mode;

import gpiolib.pins.pin;

/**
   Interface for each modes classes providing base methods usable to interface
   with file "/sys/class/gpio/gpioX/direction" and with memory registry.

   Authors:   Luca Morreale

 */
abstract class Mode {

    /**
       Returns a string identifying the mode as would be read in
       "/sys/class/gpio/gpioX/direction" file.
     */
    string getMode();

    /**
       Returns a byte that represents the mode in the registry (without shifting);
       as would be read in "/dev/mem"
     */
    ubyte binaryMode();
}
