// Includes a local file with the same name as a system library

#include "string.c"

char* STR = "camelot!";

char* const SCREEN = 0x0400;

void main() {
    SCREEN [0] = (char) strlen(STR);
}