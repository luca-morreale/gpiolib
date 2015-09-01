module attuators.memoryattuator;

import attuators.attuator;
import std.bitmanip;
import std.mmfile;
import core.time;
import core.thread;


class MemoryAttuator : Attuator, ValueVisitor, ModeVisitor {

    private static MemoryAttuator manager;

    public static Attuator factory() {
        if(manager is null) {
            manager = new MemoryAttuator();
        }
        return manager;
    }

    private const string memPath = "/dev/mem";

    private const size_t K = 1024;
    private const size_t window = 4*K;
    private const size_t size = K*K*K;

    private const ulong baseAddress = 0x20000000;
    private const ulong gpioAddress = baseAddress + 0x00200000;

    private const ubyte pinMask = 31;

    private const uint modeOffset = 0;
    private const uint setOffset = 7;
    private const uint clearOffset = 10;
    private const uint levelOffset = 13;
    private const uint gppudOffset = 37;

    private MmFile memFile;

    private this() {
        this.memFile = new MmFile(memPath, MmFile.Mode.readWrite, size, cast(void*) gpioAddress, window);
    }

    public override Pin exportPin(uint pin) {
        return new DigitalPin(pin, 0, this);
    }

    public override void unexportPin(Pin pin) {
        clearGPIO(pin);
        writeMode(pin, Input());
    }

    public override void writeMode(Pin pin, Mode mode) {
        mode.executeVisitor(this, pin);
    }

    public void inputGPIOMode(Pin pin) {
        auto gpioNumber = pin.gpioNumber;
        auto offset = gpioNumber / 10;

        ubyte[4] memory = getMemoryRangeFrom(offset);
        auto data = convertMemory(memory) & ~shift(7, offset);
        memory[] = createMemoryReplacement(data)[];
    }

    public void outputGPIOMode(Pin pin) {
        auto gpioNumber = pin.gpioNumber;
        auto offset = gpioNumber / 10;

        ubyte[4] memory = getMemoryRangeFrom(offset);
        auto data = (convertMemory(memory) & ~shift(7, offset)) | shift(gpioNumber);
        memory[] = createMemoryReplacement(data)[];
    }

    public override void writeValue(Pin pin, Value value) {
        value.executeVisitor(this, pin);
    }

    public void clearGPIO(Pin pin) {
        //This also write 0 over all other pins, but this won't have any effects
        auto replacement = createMemoryReplacement(shift(pin.gpioNumber));
        auto memory = getMemoryRangeFrom(clearOffset);
        memory[] = replacement[];
    }

    public void setGPIO(Pin pin) {
        //This also write 0 over all other pins, but this won't have any effects
        auto replacement = createMemoryReplacement(shift(pin.gpioNumber));
        auto memory = getMemoryRangeFrom(setOffset);
        memory[] = replacement[];
    }

    public override Mode readMode(Pin pin) {
        auto gpioNumber = pin.gpioNumber;
        auto offset = gpioNumber / 10;

        ubyte[4] memory = getMemoryRangeFrom(offset);
        auto data = convertMemory(memory) & shift(7, offset);

        return modesFactory(data >>> offset);
    }

    public override Value readValue(Pin pin) {
        auto gpio = pin.gpioNumber;
        ubyte[4] levels = getMemoryRangeFrom(levelOffset);
        auto value = convertMemory(levels) & shift(gpio);

        return valuesFactory(value);
    }

    public override void setPullUp(Pin pin) {
        setResistor(2, pin.gpioNumber);
    }

    public override void setPullDown(Pin pin) {
        setResistor(1, pin.gpioNumber);
    }

    private void setResistor(ubyte pullMode, uint pin) {
        uint offset = pin / 32;      //32 per registro!

        getMemoryRangeFrom(gppudOffset)[] = createMemoryReplacement(pullMode)[];
        sleep(5);
        getMemoryRangeFrom(offset)[] = createMemoryReplacement(shift(pin))[];
        sleep(5);

        getMemoryRangeFrom(gppudOffset)[] = createMemoryReplacement(0)[];
        sleep(5);
        getMemoryRangeFrom(offset)[] = createMemoryReplacement(0)[];
        sleep(5);
    }

    private ubyte[] getMemoryRangeFrom(uint start) {
        return cast(ubyte[]) memFile[start .. start + 4];
    }

    private uint convertMemory(ubyte[4] memory) {
        return bigEndianToNative!uint(memory);
    }

    private ubyte[] createMemoryReplacement(uint data) {
        ubyte[] replacement = [0, 0, 0, 0];
        replacement.write!uint(data, 0);

        return replacement;
    }

    private uint shift(uint places) {
        return shift(1, places);
    }

    private uint shift(ubyte number, uint places) {
        return number << places & pinMask;
    }

    private void sleep(uint duration) {
        Thread.sleep(dur!("usecs")(duration));
    }

}
