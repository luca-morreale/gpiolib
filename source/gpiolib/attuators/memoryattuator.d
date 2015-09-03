module gpiolib.attuators.memoryattuator;

import gpiolib.attuators.attuator;
import std.bitmanip;
import std.mmfile;
import std.algorithm;
import core.time;
import core.thread;


class MemoryAttuator : Attuator, ValueVisitor {

    private const string memPath = "/dev/mem";

    private const size_t K = 1024;
    private const size_t window = 4*K;
    private const size_t size = K*K*K;

    private const ulong baseAddress = 0x20000000;
    private const ulong gpioAddress = baseAddress + 0x00200000;

    private const ubyte pinMask = 31;

    private const uint modeOffset = 0 ;
    private const uint setOffset = 7;
    private const uint clearOffset = 10;
    private const uint levelOffset = 13;
    private const uint gppudOffset = 37;

    private MmFile memFile;

    this() {
        this.memFile = new MmFile(memPath, MmFile.Mode.readWrite, size, null, window);
    }

    public override Pin exportPin(uint pin) {
        return new DigitalPin(pin, 0, this);
    }

    public override void unexportPin(Pin pin) {
        clearGPIO(pin);
        writeMode(pin, Input());
    }

    public override void writeMode(Pin pin, Mode mode) {
        auto gpioNumber = pin.gpioNumber;
        auto offset = gpioNumber / 10;
        auto bitOffset = modeBitShift(gpioNumber);

        ubyte[] memory = getInOrderMemorySlice(offset);
        auto data = (convertMemoryToNumber(memory) & ~shift(7, bitOffset)) | shift(mode.binaryMode, bitOffset);
        writeOverMemory(offset, data);
    }

    public override void writeValue(Pin pin, Value value) {
        value.executeVisitor(this, pin);
    }

    public void clearGPIO(Pin pin) {
        //This also write 0 over all other pins, but this won't have any effects
        writeOverMemory(clearOffset, shift(pin.gpioNumber));
    }

    public void setGPIO(Pin pin) {
        //This also write 0 over all other pins, but this won't have any effects
        writeOverMemory(setOffset, shift(pin.gpioNumber));
    }

    public override Mode readMode(Pin pin) {
        auto gpioNumber = pin.gpioNumber;
        auto offset = gpioNumber / 10;

        ubyte[] memory = getInOrderMemorySlice(offset);
        auto data = convertMemoryToNumber(memory) & shift(7, modeBitShift(gpioNumber));

        return modesFactory(data >> modeBitShift(gpioNumber));
    }

    public override Value readValue(Pin pin) {
        auto gpio = pin.gpioNumber;

        ubyte[] levels = getInOrderMemorySlice(levelOffset);
        auto value = convertMemoryToNumber(levels) & shift(gpio);

        return valuesFactory(value >> gpio);
    }

    public override void setPullUp(Pin pin) {
        setResistor(2, pin.gpioNumber);
    }

    public override void setPullDown(Pin pin) {
        setResistor(1, pin.gpioNumber);
    }

    private void setResistor(ubyte pullMode, uint pin) {
        uint offset = pin / 32;      //32 per registro!

        writeOverMemory(gppudOffset, pullMode);
        sleep(5);
        writeOverMemory(offset, shift(pin));
        sleep(5);

        writeOverMemory(gppudOffset, 0);
        sleep(5);
        writeOverMemory(gppudOffset, 0);
        sleep(5);
    }

    protected ubyte[] getInOrderMemorySlice(uint start) {
        auto memory = (extractMemory(start)).dup;
        reverse(memory);
        return memory;
    }

    protected ubyte[] extractMemory(uint start) {
        ulong offset = start * uint.sizeof;
        return cast(ubyte[]) memFile[gpioAddress + offset .. gpioAddress + offset + uint.sizeof];
    }

    protected void writeOverMemory(uint start, uint data) {
        auto memory = extractMemory(start);

        auto replacement = createMemoryReplacement(data);
        reverse(replacement);

        memory[] = replacement[];
    }

    protected ubyte[] createMemoryReplacement(uint data) {
        ubyte[] replacement = [0, 0, 0, 0];
        replacement.write!uint(data, 0);

        return replacement;
    }

    protected uint convertMemoryToNumber(ubyte[] memory) {
        return memory.read!uint();
    }

    private uint modeBitShift(uint pin) {
        return (pin % 10) * 3;
    }

    protected uint shift(uint places) {
        return shift(1, places);
    }

    protected uint shift(ubyte number, uint places) {
        return number << (places & pinMask);
    }

    protected void sleep(uint duration) {
        Thread.sleep(dur!("usecs")(duration));
    }

}
