/**
    This module provide a simple implementation of Mode representing
    the input direction of the pin.

    Author: Morreale Luca
*/
module gpiolib.modes.inputmode;

import gpiolib.modes.mode;
import gpiolib.pins.pin;

final class InputMode : Mode {

    public override string getMode() {
        return "in";
    }

    public override ubyte binaryMode() {
        return 0;
    }

    public override string toString() {
        return "Mode: in";
    }

    protected static Mode factory() {
        return new InputMode;
    }
}

/**
    Simple alias to shortly create a new InputMode class.
*/
alias Input = InputMode.factory;

unittest {
    auto input = Input();

    assert(cast(InputMode)input);
    assert(input != Input());
    assert(input.binaryMode == 0);
    assert(input.getMode == "in");
}
