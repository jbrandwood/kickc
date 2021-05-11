// Test keyboard input - in the keyboard matrix and mapping screen codes to key codes

#include <c64-keyboard.h>

void main() {
    // Clear screen
    for(byte* sc = (char*)$400; sc<$400+1000;sc++) {
        *sc = ' ';
    }
    // Init keyboard
    keyboard_init();
    // Loop
    while(true) {
        do {} while (*RASTER!=$ff);
        byte* screen = (char*)$400;
        // Read & print keyboard matrix
        for(byte row : 0..7) {
            byte row_pressed_bits = keyboard_matrix_read(row);
            for(byte col : 0..7) {
                if( (row_pressed_bits & $80) != 0) {
                    screen[col] = '1';
                } else {
                    screen[col] = '0';
                }
                row_pressed_bits = row_pressed_bits * 2;
            }
            screen = screen + 40;
        }
        screen = screen + 40;
        // Checks all specific chars $00-$3f
        byte i = 0;
        for( byte ch : 0..$3f ) {
            byte key = keyboard_get_keycode(ch);
            if(key!=$3f) {
                if(keyboard_key_pressed(key)!=0) {
                    screen[i++] = ch;
                }
            }
        }
        // Add some spaces
        do {
            screen[i++] = ' ';
        } while (i<5);
    }
}
