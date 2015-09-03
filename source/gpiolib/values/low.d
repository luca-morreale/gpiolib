module gpiolib.values.low;

import gpiolib.values.value;
import gpiolib.values.visitor;
import gpiolib.pins.pin;

final class LowValue : Value {

    public override int getValue() {
        return 0;
    }

    public override void executeVisitor(ValueVisitor visitor, Pin pin) {
        visitor.clearGPIO(pin);
    }

    public override string toString() {
        return "Value: Low";
    }

    protected static Value factory() {
        return new LowValue();
    }

}

alias Low = LowValue.factory;

unittest {
    auto low = Low();

    assert(cast(LowValue)low);
    assert(low != Low());
}
