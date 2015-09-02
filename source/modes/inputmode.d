module modes.inputmode;

import modes.mode;
import modes.visitor;
import pins.pin;

final class InputMode : Mode {

    this() { }

    public string getMode() {
        return "in";
    }

    public void executeVisitor(ModeVisitor visitor, Pin pin) {
        visitor.inputGPIOMode(pin);
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
}
