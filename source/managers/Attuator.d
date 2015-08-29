module attuators.attuator;

import pins;
import modes;
import values;

abstract class Attuator {

    abstract void setMode(Pin pin, Mode mode);

    abstract void setValue(Pin pin, Value value);

    abstract Mode readMode(Pin pin);

    abstract Value readValue(Pin pin);

    abstract void setPullUp(Pin pin);

    abstract void setPullDow(Pin pin);

}
