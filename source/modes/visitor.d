module gpiolib.modes.visitor;

import gpiolib.pins.pin;

interface ModeVisitor {

    void outputGPIOMode(Pin pin);

    void inputGPIOMode(Pin pin);
}
