module gpiolib.values.low;

import gpiolib.values.value;
import gpiolib.values.visitor;
import gpiolib.pins.pin;

final class LowValue : Value {

    int getValue() {
        return 0;
    }

    void executeVisitor(ValueVisitor visitor, Pin pin) {
        visitor.clearGPIO(pin);
    }

    protected static Value factory() {
        return new LowValue();
    }

    public override string toString() {
        return "Value: Low";
    }

}

alias Low = LowValue.factory;

unittest {
    auto low = Low();

    assert(cast(LowValue)low);
    assert(low != Low());
}
