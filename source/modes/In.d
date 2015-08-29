module modes.inputmode;

import modes.mode;


final class InputMode : Mode {

    this() { }

    public string getMode() {
        return "in";
    }

    public ubyte getBinaryMode() {
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
}
