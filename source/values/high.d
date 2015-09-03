module gpiolib.values.high;

import gpiolib.values.value;
import gpiolib.values.visitor;
import gpiolib.pins.pin;

final class HighValue : Value {

    int getValue() {
        return 1;
    }

    void executeVisitor(ValueVisitor visitor, Pin pin) {
        visitor.setGPIO(pin);
    }

    protected static Value factory() {
        return new HighValue();
    }

    public override string toString() {
        return "Value: High";
    }
}

alias High = HighValue.factory;

unittest {
    auto high = High();

    assert(cast(HighValue)high);
    assert(high != High());
}
