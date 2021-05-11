// Demonstrates problem with unknown variable

char* const SCREEN = (char*)0x0400;
char* const SPRITES_PTR = SCREEN + QWE;

void main() {
    SPRITES_PTR[0] = 0;
}
