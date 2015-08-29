module modes.outputmode;

import modes.mode;


final class OutputMode : Mode {

    public string getMode() {
        return "out";
    }

    public ubyte getBinaryMode() {
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
}
