module gpiolib.modes.inputmode;

import gpiolib.modes.mode;
import gpiolib.pins.pin;

final class InputMode : Mode {

    this() { }

    public string getMode() {
        return "in";
    }

    public ubyte binaryMode() {
        return 0;
    }

    protected static Mode factory() {
        return new InputMode;
    }
}

alias Input = InputMode.factory;

unittest {
    auto input = Input();

    assert(cast(InputMode)input);
    assert(input != Input());
    assert(input.binaryMode == 0);
    assert(input.getMode == "in");
}
