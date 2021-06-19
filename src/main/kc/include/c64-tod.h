/// @file
/// Time-of-day helper
///
/// Uses the MOS6526 CIA#1 on Commodore 64

/// Time-of-day 24 hour format
struct TIME_OF_DAY {
    /// Time-of-day real-time-clock tenth seconds (BCD)
    char TENTHS;
    /// Time-of-day real-time-clock seconds (BCD)
    char SEC;
    /// Time-of-day real-time-clock minutes (BCD)
    char MIN;
    /// Time-of-day real-time-clock hours (BCD) (bit 7 is AM/PM)
    char HOURS;
};

/// Time of Day 00:00:00:00
struct TIME_OF_DAY TOD_ZERO = { 0,0,0,0 };

/// Initialize time-of-day clock
/// This uses the MOS6526 CIA#1
void tod_init(struct TIME_OF_DAY tod);

/// Read time of day
struct TIME_OF_DAY tod_read();

/// Convert time of day to a human-readable string "hh:mm:ss:10"
char* tod_str(struct TIME_OF_DAY tod);