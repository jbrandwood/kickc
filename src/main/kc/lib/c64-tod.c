// Time-of-day helper
// Uses the MOS6526 CIA#1 on Commodore 64
#include <c64-tod.h>
#include <c64.h>

// Initialize time-of-day clock
// This uses the MOS6526 CIA#1
void tod_init(struct TIME_OF_DAY tod) {
    // Set 50hz (this assumes PAL!) (bit7=1)
    CIA1->TIMER_A_CONTROL |= 0x80;
    // Writing TOD clock (bit7=0)
    CIA1->TIMER_B_CONTROL &= 0x7f;
    // Reset TOD clock
    // Writing sequence is important. TOD stops when hours is written and starts when 10ths is written.
    CIA1->TOD_HOURS = tod.HOURS;
    CIA1->TOD_MIN = tod.MIN;
    CIA1->TOD_SEC = tod.SEC;
    CIA1->TOD_10THS = tod.TENTHS;
}

// Read time of day
struct TIME_OF_DAY tod_read() {
    // Reading sequence is important. TOD latches on reading hours until 10ths is read.
    char hours = CIA1->TOD_HOURS;
    char mins = CIA1->TOD_MIN;
    char secs = CIA1->TOD_SEC;
    char tenths = CIA1->TOD_10THS;
    struct TIME_OF_DAY tod = {  tenths, secs, mins, hours };
    return tod;
}

// The buffer used by tod_str()
char tod_buffer[] = "00:00:00:00";

// Convert time of day to a human-readable string "hh:mm:ss:10"
char* tod_str(struct TIME_OF_DAY tod) {
    tod_buffer[0] = '0'+(tod.HOURS>>4);
    tod_buffer[1] = '0'+(tod.HOURS&0x0f);
    tod_buffer[3] = '0'+(tod.MIN>>4);
    tod_buffer[4] = '0'+(tod.MIN&0x0f);
    tod_buffer[6] = '0'+(tod.SEC>>4);
    tod_buffer[7] = '0'+(tod.SEC&0x0f);
    tod_buffer[9] = '0'+(tod.TENTHS>>4);
    tod_buffer[10] = '0'+(tod.TENTHS&0x0f);
    return tod_buffer;
}