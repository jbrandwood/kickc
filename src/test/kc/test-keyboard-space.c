// Test keyboard input - test the space bar
#include <keyboard.c>

void main() {
    keyboard_init();
    while(true) {
        do {} while (*RASTER!=$ff);
        if(keyboard_key_pressed(KEY_SPACE)!=0) {
            *BGCOL = GREEN;
        } else {
            *BGCOL = BLUE;
        }
    }
}