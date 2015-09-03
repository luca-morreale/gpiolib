module gpiolib.values.value;

import gpiolib.values.visitor;
import gpiolib.pins.pin;

/**
   Interface for each values classes providing base methods usable to interface
   with file "/sys/class/gpio/gpioX/value" and with memory registry.

   Authors:   Luca Morreale

 */
abstract class Value {

    /**
       Returns an int identifying the value as would be read in
       "/sys/class/gpio/gpioX/direction" file.
     */
    int getValue();

    /**
       Returns a byte that represents the value in the registry (without shifting);
       as would be read in "/dev/mem"
     */
    void executeVisitor(ValueVisitor visitor, Pin pin);

}
