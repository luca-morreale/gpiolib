/**
    This module provide an abstract representation of a digital pin values.

    Author: Morreale Luca
*/

module gpiolib.values.value;

import gpiolib.values.visitor;
import gpiolib.pins.pin;

/**
    Base class for each value type.
    It provide base methods usable to work with both FileAttuator and MemoryAttuator.
*/
abstract class Value {

    /**
        Returns an integer identifying the digital value 
        (as would be read in "/sys/class/gpio/gpioX/value" file).
     */
    int getValue();

    /**
        Execute the visitor pattern calling the right method of ValueVisitor depending on
        the class that implements this methods.
     */
    void executeVisitor(ValueVisitor visitor, Pin pin);

}
