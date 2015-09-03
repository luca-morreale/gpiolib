module gpiolib.gpio;

import gpiolib.attuators;

class GPIO(T : Attuator) {

    T attuator;

    this() {
        attuator = new T();
    }

    public Pin createPin(int gpioNumber) {
        return attuator.exportPin(gpioNumber);
    }

}
