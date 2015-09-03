module gpiolib.values.high;

import gpiolib.values.value;
import gpiolib.values.visitor;
import gpiolib.pins.pin;

final class HighValue : Value {

    public override int getValue() {
        return 1;
    }

    public override void executeVisitor(ValueVisitor visitor, Pin pin) {
        visitor.setGPIO(pin);
    }

    public override string toString() {
        return "Value: High";
    }

    protected static Value factory() {
        return new HighValue();
    }
}

alias High = HighValue.factory;

unittest {
    auto high = High();

    assert(cast(HighValue)high);
    assert(high != High());
}
