/**
    An Attuator that works with files in /sys/class/gpio path;
    it writes and reads on export, unexport, direction, value files according
    to the operation requested.

    Author: Morreale Luca
*/
module gpiolib.attuators.fileattuator;

import gpiolib.attuators.attuator;
import std.conv;
import std.file;
import std.stdio : File;
import std.exception : ErrnoException;

class FileAttuator : Attuator {

    /**
        Base path for files listed above.
    */
    private static string path = "/sys/class/gpio/";

    /**
        Creates the pins checkin if it has been already exported,
        if it's not it write over "export" file so the OS will create a subdirectory
        representing the pin specified.
    */
    public override Pin exportPin(uint pin) {
        if(!pinAlreadyExported(pin)) {
            auto exportFile = File(path ~ "export", "w");
            exportFile.write(pin);
            closeFile(exportFile);
        }
        return new DigitalPin(pin, pin, this);
    }

    /**
        Wites over the "unexport" file in order to delete the subfolder
        representing the pin.
    */
    public override void unexportPin(Pin pin) {
        auto unexportFile = File(path ~ "unexport", "w");
        unexportFile.write(pin.gpioNumber);
        closeFile(unexportFile);
    }

    public override void writeMode(Pin pin, Mode mode) {
        auto directionFile = File(generateDirectoryPath(pin) ~ "direction", "w");
        directionFile.write(mode.getMode);
        closeFile(directionFile);
    }

    public override Mode readMode(Pin pin) {
        auto directionFile = File(generateDirectoryPath(pin) ~ "direction", "r");
        auto direction = directionFile.readln();
        closeFile(directionFile);

        return modesFactory(direction);
    }

    public override void writeValue(Pin pin, Value val) {
        auto valueFile = File(generateDirectoryPath(pin) ~ "value", "w");
        valueFile.write(val.getValue);
        closeFile(valueFile);
    }

    public override Value readValue(Pin pin) {
        auto valueFile = File(generateDirectoryPath(pin) ~ "value", "r");
        auto value = valueFile.readln();
        closeFile(valueFile);

        return valuesFactory(value);
    }

    public override void setPullUp(Pin pin) {
        throw new Exception("Pull-Up operation isn't implemented in FileAttuator.");
    }

    public override void setPullDown(Pin pin) {
        throw new Exception("Pull-Down operation isn't implemented in FileAttuator.");
    }

    /**
        Checks if the subfolder gpioX exists, where X is the number of the pin.
    */
    private bool pinAlreadyExported(int pin) {
        foreach (DirEntry e; dirEntries(path, SpanMode.shallow)) {
            if(e.name == "gpio" ~ to!string(pin)) {
                return true;
            }
        }
        return false;
    }

    private string generateDirectoryPath(Pin pin) {
        return path ~ "gpio" ~ to!string(pin.gpioNumber) ~ "/";
    }

    /**
        Close safly the file open and flush it's buffer.
    */
    private void closeFile(ref File file) {
        try {
            file.flush();
            file.close();
        } catch (ErrnoException e) { }
    }
}

