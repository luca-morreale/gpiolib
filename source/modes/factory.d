module gpiolib.modes.factory;

import std.string;
import gpiolib.modes.inputmode;
import gpiolib.modes.outputmode;
import gpiolib.modes.mode;

Mode modesFactory(string value) {
    switch(value.toLower.strip) {
        case "in":
            return Input();
        case "out":
            return Output();
        default:
            throw new Exception("Mode requested does not exist!");
    }
}

Mode modesFactory(int value) {
    switch(value) {
        case 0:
            return Input();
        case 1:
            return Output();
        default:
            throw new Exception("Mode requested does not exist!");
    }
}
