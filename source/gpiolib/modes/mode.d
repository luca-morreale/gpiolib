/**
    This module provide an abstract representation of modes available for the board.

    Author: Morreale Luca
*/

module gpiolib.modes.mode;

import gpiolib.pins.pin;

/**
    Base class for each mode type.
    It provide base methods usable to work with both FileAttuator and MemoryAttuator.
*/
abstract class Mode {

    /**
       Returns an integer identifying the mode 
        (as would be read in "/sys/class/gpio/gpioX/direction" file).
     */
    string getMode();

    /**
        Returns a byte that represents the mode in the registry (without shifting).
     */
    ubyte binaryMode();
}
