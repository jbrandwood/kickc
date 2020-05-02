// Test keyboard input - test the space bar
#include <keyboard.h>

void main() {
    keyboard_init();
    while(true) {
        do {} while (*RASTER!=$ff);
        if(keyboard_key_pressed(KEY_SPACE)!=0) {
            *BG_COLOR = GREEN;
        } else {
            *BG_COLOR = BLUE;
        }
    }
}
