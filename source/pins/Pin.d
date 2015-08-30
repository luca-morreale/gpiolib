module pins.pin;

import modes;
import values;

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
        this.setMode(Output());
    }

    public void inputMode() {
        this.setMode(Input());
    }

    public Mode readMode() {
        return mode;
    }

    public void setValue(Value value) {
        this.value = value;
    }

    public void high() {
        this.setValue(High());
    }

    public void low() {
        this.setValue(Low());
    }

    public Value readValue() {
        return value;
    }

    abstract void pullUp();

    abstract void pullDown();


    public final int gpioNumber() {
        return pinNumber;
    }

    public final int physicalPinNumber() {
        return physicalNumber;
    }
}


