/**
    Simple factory methods useable to translate string or number
    to the corresponding Value class.

    Author: Morreale Luca
*/
module gpiolib.values.factory;

import std.conv;
import std.string;
import gpiolib.values.high;
import gpiolib.values.low;
import gpiolib.values.value;

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
