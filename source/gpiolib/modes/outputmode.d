/**
    This module provide a simple implementation of Mode representing
    the output direction of the pin.

    Author: Morreale Luca
*/
module gpiolib.modes.outputmode;

import gpiolib.modes.mode;
import gpiolib.pins.pin;

final class OutputMode : Mode {

    public override string getMode() {
        return "out";
    }

    public override ubyte binaryMode() {
        return 1;
    }

    public override string toString() {
        return "Mode: out";
    }

    protected static Mode factory() {
        return new OutputMode;
    }
}

/**
    Simple alias to shortly create a new OutputMode class.
*/
alias Output = OutputMode.factory;

unittest {
    auto output = Output();

    assert(cast(OutputMode)output);
    assert(output != Output());
    assert(output.binaryMode == 1);
    assert(output.getMode == "out");
}
