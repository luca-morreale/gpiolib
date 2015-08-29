module values.value;

/**
   Interface for each values classes providing base methods usable to interface
   with file "/sys/class/gpio/gpioX/value" and with memory registry.

   Authors:   Luca Morreale

 */
interface Value {

    /**
       Returns an int identifying the value as would be read in
       "/sys/class/gpio/gpioX/direction" file.
     */
    int getValue();

    /**
       Returns a byte that represents the value in the registry (without shifting);
       as would be read in "/dev/mem"
     */
    ubyte getBinaryValue();

}
