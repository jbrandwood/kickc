// Tests problem writing/reading joystick encountered by Danny Spijksma
// https://www.protovision.games/hardw/build4player.php?language=en&fbclid=IwAR1MJLgQjOU0zVa0ax2aNeGa-xVbE9IGY9zC6b6eInTV4HQzoUAoCPoXu14

#include <c64.h>
char* const SCREEN = 0x0400;
void main() {
    (*CIA2_PORT_B) &= 0x7f;
    asm { lda #0 }
    char port4Value = *CIA2_PORT_B;
    *SCREEN = port4Value;
}