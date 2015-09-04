/**
    An Attuator that works with memory registry conteined in file /dev/mem;
    it writes or reads on specified addresses according
    to the operation requested.

    See datasheet of BCM2835 for specs: http://www.farnell.com/datasheets/1521578.pdf

    Author: Morreale Luca
*/
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

    /**
        Physical address of ARM IO peripherals
    */
    private const ulong baseAddress = 0x20000000;

    /**
        GPIO address
    */
    private const ulong gpioAddress = baseAddress + 0x00200000;

    /**

    */
    private const ubyte pinMask = 31;

    /**
        Offset for Set Register
    */
    private const uint setOffset = 7;

    /**
        Offset for Clear Register
    */
    private const uint clearOffset = 10;

    /**
        Offset for Level Register
    */
    private const uint levelOffset = 13;

    /**
        Offset for GPIO Pull-up/down Register
    */
    private const uint gppudOffset = 37;

    /**
        Offset for GPIO Pull-up/down Clock Register
    */
    private const uint gppudClkOffset = 38;

    private MmFile memFile;

    this() {
        this.memFile = new MmFile(memPath, MmFile.Mode.readWrite, size, null, window);
    }

    public override Pin exportPin(uint pin) {
        return new DigitalPin(pin, 0, this);
    }

    /**
        Resets the status of the pin just making it an input at low level.
    */
    public override void unexportPin(Pin pin) {
        clearGPIO(pin);
        writeMode(pin, Input());
    }

    /**
        Writes the mode code over the correct address, calculated adding from the gpio base address
        an offset of 1 (32 bit) for each decade in the pin number. (see BCM datasheet page 91)
    */
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

    /**
        This will write 1 over the bit identifying the pin and 0 over each other in CLEAR register
        (this won't affect other's pin function).
    */
    public void clearGPIO(Pin pin) {
        writeOverMemory(clearOffset, shift(pin.gpioNumber));
    }

    /**
        This will write 1 over the bit identifying the pin and 0 over each other in SET register
        (this won't affect other's pin function).
    */
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

    /**
        Sets up pull resistors.
        (see BCM datasheet for sequence events spec)
    */
    private void setResistor(ubyte pullMode, uint pin) {

        writeOverMemory(gppudOffset, pullMode);
        sleep(5);
        writeOverMemory(gppudClkOffset, shift(pin));
        sleep(5);

        writeOverMemory(gppudOffset, 0);
        sleep(5);
        writeOverMemory(gppudClkOffset, 0);
        sleep(5);
    }

    /**
        Extract a slice of memory and reverse it, 
        the less significant bit goes to the right.
    */
    protected ubyte[] getInOrderMemorySlice(uint start) {
        auto memory = (extractMemory(start)).dup;
        reverse(memory);
        return memory;
    }

    protected ubyte[] extractMemory(uint start) {
        ulong offset = start * uint.sizeof;
        return cast(ubyte[]) memFile[gpioAddress + offset .. gpioAddress + offset + uint.sizeof];
    }

    /**
        Writes data, converting into bits, over the memory from the given offset.
    */
    protected void writeOverMemory(uint start, uint data) {
        auto memory = extractMemory(start);

        auto replacement = createMemoryReplacement(data);
        reverse(replacement);

        memory[] = replacement[];
    }

    /**
        Translates data into bits.
    */
    protected ubyte[] createMemoryReplacement(uint data) {
        ubyte[] replacement = [0, 0, 0, 0];
        replacement.write!uint(data, 0);

        return replacement;
    }

    /**
        Convert a slice of memory into a number.
        (the less significant bit must be on the right)
    */
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
