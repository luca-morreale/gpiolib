/**
    Base representation of a GPIO on the board.

    Author: Morreale Luca
*/
module gpiolib.pins.pin;

import gpiolib.modes;
import gpiolib.values;

abstract class Pin {

    /**
        Current mode of the pin.
    */
    private Mode mode;

    /**
        Current value of the pin.
    */
    private Value value;

    /**
        Number of the GPIO.
    */
    private uint pinNumber;

    /**
        Number of the physical pin of this GPIO.
    */
    private uint physicalNumber;

    /**
        Short constructor to create a pin in InputMode and with LowValue.
    */
    this(uint pin, uint physPin) {
        this(pin, physPin, Input(), Low());
    }

    this(uint pin, uint physPin, Mode mode, Value value) {
        this.pinNumber = pin;
        this.physicalNumber = physPin;
        this.mode = mode;
        this.value = value;
    }

    public void setMode(Mode mode) {
        this.mode = mode;
    }

    /**
        Shortcut to set output mode.
    */
    public void outputMode() {
        setMode(Output());
    }

    /**
        Shortcut to set input mode.
    */
    public void inputMode() {
        setMode(Input());
    }

    public Mode readMode() {
        return mode;
    }

    public void setValue(Value value) {
        this.value = value;
    }

    /**
        Shortcut to set high value.
    */
    public void high() {
        setValue(High());
    }

    /**
        Shortcut to set low value.
    */
    public void low() {
        setValue(Low());
    }

    public Value readValue() {
        return value;
    }

    abstract void pullUp();

    abstract void pullDown();

    abstract void close();

    public final uint gpioNumber() {
        return pinNumber;
    }

    public final uint physicalPinNumber() {
        return physicalNumber;
    }
}


