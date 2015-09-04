/**
    This module provide the interface for the visitor pattern used by Value class,
    needed only when working with MemoryAttuator.

    Author: Morreale Luca 
*/
module gpiolib.values.visitor;

import gpiolib.pins.pin;

interface ValueVisitor {

    /**
        Methods called to set the value low.
    */
    void clearGPIO(Pin pin);

    /**
        Methods called to set the value high.
    */
    void setGPIO(Pin pin);
}
