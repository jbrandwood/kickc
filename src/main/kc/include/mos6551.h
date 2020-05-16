// MOS 6551 6551 ASYNCHRONOUS COMMUNICATION INTERFACE ADAPTER
// used for RS232
// http://archive.6502.org/datasheets/mos_6551_acia.pdf
//  https://en.wikipedia.org/wiki/MOS_Technology_6551

struct MOS6551_ACIA {
    // DATA port
    char DATA;
    // STATUS port
    char STATUS;
    // COMMAND port
    char COMMAND;
    // CONTROL port
    char CONTROL;
};