/// @file
/// MOS 6522 Versatile Interface Adapter (VIA)
/// Used in VIC 20 and 1541
/// https://en.wikipedia.org/wiki/MOS_Technology_6522
/// http://archive.6502.org/datasheets/mos_6522_preliminary_nov_1977.pdf

struct MOS6522_VIA {
    /// Port B
    char PORT_B;
    /// Port A
    char PORT_A;
    /// Port B data direction register.
    char PORT_B_DDR;
    /// Port A data direction register.
    char PORT_A_DDR;
    /// Timer 1 low byte
    char TIMER1_LOW;
    /// Timer 1 high byte
    char TIMER1_HIGH;
    /// Timer 1 latch low byte
    char TIMER1_LATCH_LOW;
    /// Timer 1 latch high byte
    char TIMER1_LATCH_HIGH;
    /// Timer 2 low byte
    char TIMER2_LOW;
    /// Timer 2 high byte
    char TIMER2_HIGH;
    /// Shift Register
    char SHIFT;
    /// Auxiliary Control Register
    char AUX_CONTROL;
    /// Peripheral Control Register
    char PERIPHERAL_CONTROL;
    /// Interrupt Flag Register
    char INTERRUPT_FLAG;
    /// Interrupt Enable Register
    char INTERRUPT_ENABLE;
    /// Port A Output (no handshake)
    char PORT_A_OUTPUT;
};