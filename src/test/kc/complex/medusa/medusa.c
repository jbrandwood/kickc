// Display  MEDUSA PETSCII by Buzz_clik
// https://csdb.dk/release/?id=178673

#include <c64.h>
#include <string.h>

char MEDUSA_SCREEN[1000] = kickasm(resource "medusas.prg" ) {{
    .var fileScreen = LoadBinary("medusas.prg", BF_C64FILE)
    .fill fileScreen.getSize(), fileScreen.get(i)
}};


char MEDUSA_COLORS[] = kickasm(resource "medusac.prg" ) {{
    .var fileCols = LoadBinary("medusac.prg", BF_C64FILE)
    .fill fileCols.getSize(), fileCols.get(i)
}};

byte* SCREEN = 0x0400;

void main() {
    *BGCOL = BLACK;
    memcpy(SCREEN, MEDUSA_SCREEN, 1000);
    memcpy(COLS, MEDUSA_COLORS, 1000);
    while(true) {
        (*(SCREEN+999)) ^= 0x0e;
    }
}
