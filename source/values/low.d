module values.low;

import values.value;
import values.visitor;
import pins.pin;

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

}

alias Low = LowValue.factory;

unittest {
    auto low = Low();

    assert(cast(LowValue)low);
    assert(low != Low());
}
