module attuators.attuator;

package import pins;
package import modes;
package import values;

abstract class Attuator {

    abstract Pin exportPin(uint pin);

    abstract void unexportPin(Pin pin);

    abstract void writeMode(Pin pin, Mode mode);

    abstract void writeValue(Pin pin, Value value);

    abstract Mode readMode(Pin pin);

    abstract Value readValue(Pin pin);

    abstract void setPullUp(Pin pin);

    abstract void setPullDown(Pin pin);

}
