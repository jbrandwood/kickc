#include "imported.c"

void main() {
    byte* screen = $0400;
    *screen = 1;
    *BG_COLOR = RED;
}