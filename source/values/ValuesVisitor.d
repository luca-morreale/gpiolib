module values.visitor;

import pins.pin;

interface ValueVisitor {

    void clearGPIO(Pin pin);

    void setGPIO(Pin pin);
}
