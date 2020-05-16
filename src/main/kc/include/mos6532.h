// MOS 6532 RAM-I/O-Timer (RIOT)
// http://www.ionpool.net/arcade/gottlieb/technical/datasheets/R6532_datasheet.pdf
// http://www.qotile.net/minidig/docs/stella.pdf
// https://en.wikipedia.org/wiki/MOS_Technology_6532

struct MOS6532_RIOT {
    // $280 Port A data register for joysticks: Bits 4-7 for player 1.  Bits 0-3 for player 2.
    char SWCHA;
    // $281 Port A data direction register (DDR)
    char SWACNT;
    // $282 Port B data (console switches)
    char SWCHB;
    // $283 Port B DDR
    char SWBCNT;
    // $284 Timer output
    char INTIM;
    // Unused/undefined registers ($285-$294)
    char UNUSED[15];
    // $294 set 1 clock interval
    char TIM1T;
    // $295 set 8 clock interval
    char TIM8T;
    // $296 set 64 clock interval
    char TIM64T;
    // $297 set 1024 clock interval
    char T1024T;
};
