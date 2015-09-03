module gpiolib.pins.pin;

import gpiolib.modes;
import gpiolib.values;

abstract class Pin {

    private Mode mode;
    private Value value;
    private uint pinNumber;
    private uint physicalNumber;

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

    public void outputMode() {
        setMode(Output());
    }

    public void inputMode() {
        setMode(Input());
    }

    public Mode readMode() {
        return mode;
    }

    public void setValue(Value value) {
        this.value = value;
    }

    public void high() {
        setValue(High());
    }

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


