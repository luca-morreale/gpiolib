module values.low;

import values.value;

final class LowValue : Value {

    int getValue() {
        return 0;
    }

    ubyte getBinaryValue() {
        return 0;
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
