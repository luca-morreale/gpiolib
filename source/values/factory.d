module values.factory;

import std.conv;
import std.string;
import values.high;
import values.low;
import values.value;

Value valuesFactory(string value) {
    return valuesFactory(to!int(value.strip));
}

Value valuesFactory(int value) {

    switch(value) {
        case 0:
            return Low();
        case 1:
            return High();
        default:
            throw new Exception("Value requested does not exist!");
    }
}
