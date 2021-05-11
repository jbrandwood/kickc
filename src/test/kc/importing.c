#include "imported.c"

void main() {
    byte* screen = (byte*)$400;
    *screen = 1;
    *BG_COLOR = RED;
}