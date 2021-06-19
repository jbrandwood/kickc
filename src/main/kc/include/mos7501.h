/// @file
/// MOS 7501/8501 MICROPROCESSOR
/// https://en.wikipedia.org/wiki/MOS_Technology_6510

/// The processor port of the MOS 7501 CPU
/// http://hackjunk.com/2017/06/23/commodore-16-plus-4-8501-to-6510-cpu-conversion/
struct MOS7501_PORT {
    /// The data direction of the port
    char DDR;
    /// The on-chip processor port
    ///   P0: SER DAT OUT
    ///   P1: SER CLK OUT / CASS WRT
    ///   P2: SER ATN OUT
    ///   P3: CASS MOTOR
    ///   P4: CASS READ
    ///   P6: SER CLK IN
    ///   P7: SER DAT IN
    char PORT;
};