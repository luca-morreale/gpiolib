module modes.outputmode;

import modes.mode;
import modes.visitor;
import pins.pin;


final class OutputMode : Mode {

    public string getMode() {
        return "out";
    }

    public void executeVisitor(ModeVisitor visitor, Pin pin) {
        visitor.outputGPIOMode(pin);
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
}
