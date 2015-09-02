module gpiolib.values.visitor;

import gpiolib.pins.pin;

interface ValueVisitor {

    void clearGPIO(Pin pin);

    void setGPIO(Pin pin);
}
