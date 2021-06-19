/// C standard library time.h
///  Functions to get and manipulate date and time information.

/// Type suitable for storing the processor time.
typedef unsigned long clock_t;

/// Clock cycles per frame (on a C64 PAL)
const unsigned int CLOCKS_PER_FRAME = 19656;

/// Frames per second (on a C64 PAL)
const char FRAMES_PER_SEC = 60;

/// Clock cycles per second (on a C64 PAL)
const clock_t CLOCKS_PER_SEC = CLOCKS_PER_FRAME*FRAMES_PER_SEC;

/// Clock cycles used to start & read the cycle clock by calling clock_start() and clock() once. Can be subtracted when calculating the number of cycles used by a routine.
/// To make precise cycle measurements interrupts and the display must be disabled so neither steals any cycles from the code.
const unsigned long CLOCKS_PER_INIT = 0x12;

/// Returns the processor clock time used since the beginning of an implementation defined era (normally the beginning of the program).
/// This uses CIA #2 Timer A+B on the C64, and must be initialized using clock_start()
clock_t clock(void);

/// Reset & start the processor clock time. The value can be read using clock().
/// This uses CIA #2 Timer A+B on the C64
void clock_start(void);
