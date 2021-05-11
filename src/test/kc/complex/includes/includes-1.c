// Includes a system library - ignores the local file with the same name

#include <string.h>

char* STR = "camelot!";

char* const SCREEN = (char*)0x0400;

void main() {
    SCREEN [0] = (char) strlen(STR);
}