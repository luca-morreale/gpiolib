module modes.visitor;

import pins.pin;

interface ModeVisitor {

    void outputGPIOMode(Pin pin);

    void inputGPIOMode(Pin pin);
}
