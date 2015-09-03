module gpiolib.modes.outputmode;

import gpiolib.modes.mode;
import gpiolib.pins.pin;


final class OutputMode : Mode {

    public string getMode() {
        return "out";
    }

    public ubyte binaryMode() {
        return 1;
    }

    protected static Mode factory() {
        return new OutputMode;
    }
}

alias Output = OutputMode.factory;

unittest {
    auto output = Output();

    assert(cast(OutputMode)output);
    assert(output != Output());
    assert(input.binaryMode == 1);
    assert(input.getMode == "out");
}
