module gpiolib.pins.digitalpin;

import gpiolib.attuators;
import gpiolib.pins.pin;
import gpiolib.modes;
import gpiolib.values;

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
        attuator.unexportPin(this);
    }

    public override void setMode(Mode mode) {
        super.setMode(mode);
        attuator.writeMode(this, mode);
    }

    public override void outputMode() {
        super.outputMode();
    }

    public override void inputMode() {
        super.inputMode();
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

    public override void high() {
        super.high();
    }

    public override void low() {
        super.low();
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
}
