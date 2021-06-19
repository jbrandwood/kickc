/// MOS 6523 TRI-PORT INTERFACE (TPI)
/// It has three dedicated 8-bit I/O ports which provide 24 individually programmable I/O lines
/// Used in the Commodore 1551 disk drive
/// http://archive.6502.org/datasheets/mos_6523_tpi_preliminary_nov_1980.pdf

struct MOS6523_TIA {
    // Port A
    char PORT_A;
    // Port B
    char PORT_B;
    // Port C
    char PORT_C;
    // Port A data direction register.
    char PORT_A_DDR;
    // Port B data direction register.
    char PORT_B_DDR;
    // Port C data direction register.
    char PORT_C_DDR;
}