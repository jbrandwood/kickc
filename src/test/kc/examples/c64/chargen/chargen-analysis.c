// Allows analysis of the CHARGEN ROM font
#include <c64.h>
#include <c64-keyboard.h>

char* SCREEN = (char*)$400;

void main() {
    // Clear screen
    for( char* sc=SCREEN;sc<SCREEN+1000;sc++) *sc = ' ';

    // Plot 4 initial analysis chars
    print_str_at("f1", SCREEN+1);
    print_str_at("f3", SCREEN+1+10);
    print_str_at("f5", SCREEN+1+20);
    print_str_at("f7", SCREEN+1+30);
    for(char i : 0..3 ) {
        plot_chargen(i, $20, 0);
    }

    // Which char canvas to use
    char cur_pos = 0;

    // Is shift pressed
    char shift = 0;

    do{
        // Set current char canvas #pos based on F-keys pressed
        if(keyboard_key_pressed(KEY_F1)!=0) {
            cur_pos = 0;
        }
        if(keyboard_key_pressed(KEY_F3)!=0) {
            cur_pos = 1;
        }
        if(keyboard_key_pressed(KEY_F5)!=0) {
            cur_pos = 2;
        }
        if(keyboard_key_pressed(KEY_F7)!=0) {
            cur_pos = 3;
        }

        if(keyboard_key_pressed(KEY_LSHIFT)!=0) {
            shift = 1;
        } else {
            shift = 0;
        }

        // Check for key presses - and plot char if found
        for( char ch : 0..$3f) {
            char pressed = 0;
            char key = keyboard_get_keycode(ch);
            if(key!=$3f) {
                pressed = keyboard_key_pressed(key);
            }
            if(pressed!=0) {
                plot_chargen(cur_pos, ch, shift);
            }
        }
    } while(true);
}

// Print a string at a specific screen position
void print_str_at(char* str, char* at) {
    while(*str) {
        *(at++) = *(str++);
    }
}

// Render 8x8 char (ch) as pixels on char canvas #pos
void plot_chargen(char pos, char ch, char shift) {
    asm { sei }
    char* chargen = CHARGEN+(unsigned int)ch*8;
    if(shift!=0) {
        chargen = chargen + $0800;
    }
    *PROCPORT = $32;
    char* sc = SCREEN + 41 + pos*10;
    for(char y:0..7) {
      char bits = chargen[y];
      for(char x:0..7) {
        char c = '.';
        if((bits & $80) != 0) {
           c = '*';
        }
        *sc = c;
        sc++;
        bits = bits*2;
      }
      sc = sc+32;
    }
    *PROCPORT = $37;
    asm { cli }
}
