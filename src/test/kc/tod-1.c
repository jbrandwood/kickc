// Time of Day / RTOS test using the 6526 CIA on C64
#include <conio.h>
#include <tod.h>

void main() {
    tod_init(TOD_ZERO);
    while(1) {
        struct TIME_OF_DAY tod = tod_read();
        gotoxy(0,0);
        cputs(tod_str(tod));
    }
}
