module values.high;

import values.value;

final class HighValue : Value {

    int getValue() {
        return 1;
    }

    ubyte getBinaryValue() {
        return 1;
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
