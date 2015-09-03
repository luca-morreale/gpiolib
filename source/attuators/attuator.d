module gpiolib.attuators.attuator;

package import gpiolib.pins;
package import gpiolib.modes;
package import gpiolib.values;

interface Attuator {

    abstract Pin exportPin(uint pin);

    abstract void unexportPin(Pin pin);

    abstract void writeMode(Pin pin, Mode mode);

    abstract void writeValue(Pin pin, Value value);

    abstract Mode readMode(Pin pin);

    abstract Value readValue(Pin pin);

    abstract void setPullUp(Pin pin);

    abstract void setPullDown(Pin pin);

}
