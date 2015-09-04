/**
    Base implementation of the abstract representation of a Pin.

    Author: Morreale Luca
*/
module gpiolib.pins.digitalpin;

import gpiolib.attuators;
import gpiolib.pins.pin;
import gpiolib.modes;
import gpiolib.values;

/**
    This class provide base functionality for pins that work only with digital values;
    it allows to set/read values using Pin's class methods.

    Remember to free the pin after you have finished calling close() method.
*/
class DigitalPin : Pin {

    private Attuator attuator;

    this(uint pin, uint physPin, Attuator attuator) {
        super(pin, physPin);
        this.attuator = attuator;
        readMode();
        readValue();
    }

    this(uint pin, uint physPin, Mode mode, Value value, Attuator attuator) {
        super(pin, physPin, mode, value);
        this.attuator = attuator;
    }

    ~this() {
        if(attuator !is null) {
            close();
        }
    }

    public override void setMode(Mode mode) {
        super.setMode(mode);
        attuator.writeMode(this, mode);
    }

    public override Mode readMode() {
        auto mode = attuator.readMode(this);
        super.setMode(mode);
        return mode;
    }

    public override void setValue(Value value) {
        super.setValue(value);
        attuator.writeValue(this, value);
    }

    public override Value readValue() {
        auto value = attuator.readValue(this);
        super.setValue(value);
        return value;
    }

    public override void pullUp() {
        attuator.setPullUp(this);
    }

    public override void pullDown() {
        attuator.setPullDown(this);
    }

    public override void close() {
        attuator.unexportPin(this);
    }

    public override string toString() {
        auto pin = super.gpioNumber();
        auto value = super.readValue();
        auto mode = super.readMode();

        return "Pin " ~ std.conv.to!string(pin) ~ ": " ~ mode.toString ~ " ," ~ value.toString;
    }

}
