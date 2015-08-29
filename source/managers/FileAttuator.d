module attuators.fileattuator;

import attuators.attuator;
import std.conv;
import std.stdio;
import std.file;

class FileAttuator : Attuator {

    private static FileAttuator manager;
    private static string path = "/sys/class/gpio/";

    public static FileAttuator factory() {

        if(manager is null) {
            manager = new FileAttuator();
        }
        return manager;
    }

    private this() { }

    public override void exportPin(int pin) {
        if(!pinAlreadyExported(pin)) {
            auto exportFile = File(path~"export", "w");
            exportFile.write(pin);
        }
    }

    public override void unexportPin(Pin pin) {
        auto unexportFile = File(path ~ "unexport", "w");
        unexportFile.write(pin.gpioNumber);
    }

    public override void writeMode(Pin pin, Mode mode) {
        auto directionFile = File(generateDirectoryPath(pin) ~ "direction", "w");
        directionFile.write(mode.getMode);
    }

    public override Mode readMode(Pin pin) {
        auto directionFile = File(generateDirectoryPath(pin) ~ "direction", "r");
        auto direction = directionFile.readln();

        return modesFactory(direction);
    }

    public override void writeValue(Pin pin, Value val) {
        auto valueFile = File(generateDirectoryPath(pin) ~ "value", "w");
        valueFile.write(val.getValue);
    }

    public override Value readValue(Pin pin) {
        auto valueFile = File(generateDirectoryPath(pin) ~ "value", "r");
        auto value = valueFile.readln();

        return valuesFactory(value);
    }

    public override void setPullUp(Pin pin) {
        throw new Exception("Pull-Up operation isn't implemented with usig file manger");
    }

    public override void setPullDow(Pin pin) {
        throw new Exception("Pull-Down operation isn't implemented with usig file manger");
    }

    private bool pinAlreadyExported(int pin) {
        foreach (DirEntry e; dirEntries(path, SpanMode.breadth)) {
            if(e.name == "gpio" ~ to!string(pin)) {
                return true;
            }
        }
        return false;
    }

    private string generateDirectoryPath(Pin pin) {
        return path ~ "gpio" ~ to!string(pin.gpioNumber) ~ "/";
    }
}

