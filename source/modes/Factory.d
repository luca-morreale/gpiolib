module modes.factory;

import std.string;
import modes.inputmode;
import modes.outputmode;
import modes.mode;

Mode modesFactory(string value) {
    switch(value.toLower) {
        case "in":
            return Input();
        case "out":
            return Output();
        default:
            throw new Exception("Mode requested does not exist!");
    }
}
