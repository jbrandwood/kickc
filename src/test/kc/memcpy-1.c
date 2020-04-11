// Test memcpy on strings (

#include <string.c>

char* const SCREEN = 0x0400;
const char CAMELOT[] = "camelot";

void main() {
    // Working memory copy of string
    char* sc = SCREEN;
    char* camelot= CAMELOT;
    for( char i: 0..6) {
        *sc++ = *camelot++;
     }
    char* sc2 = SCREEN+40;
    char* reigns = "reigns";
    for( char i: 0..5) {
        *sc2++ = *reigns++;
     }

    memcpy(SCREEN+10, CAMELOT, 7);
    memcpy(SCREEN+50, "rules", 5);

}