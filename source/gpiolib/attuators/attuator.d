/**
    Interface for an object that really will changes values and modes of pins.

    Author: Morreale Luca
*/
module gpiolib.attuators.attuator;

package import gpiolib.pins;
package import gpiolib.modes;
package import gpiolib.values;

interface Attuator {

    /**
        Creates the pin according to the type of attuator choosen.
    */
    abstract Pin exportPin(uint pin);

    /**
        Resets and deletes the pin.
    */
    abstract void unexportPin(Pin pin);

    /**
        Changes the mode of the pin.
    */
    abstract void writeMode(Pin pin, Mode mode);

    /**
        Changes the value of the pin.
    */
    abstract void writeValue(Pin pin, Value value);

    /**
        Reads the mode of the pin.
    */
    abstract Mode readMode(Pin pin);

    /**
        Reads the value of the pin.
    */
    abstract Value readValue(Pin pin);

    /**
        Sets the pin as Pull-Up.
    */
    abstract void setPullUp(Pin pin);

    /**
        Sets the pin as Pull-Down.
    */
    abstract void setPullDown(Pin pin);

}
