// Exploring keyboard glitch that finds "C" press when pressing space
// The glitch is caused by the "normal" C64 interrupt occuring just as the keyboard is read.
// Press "I" to disable interrupts (red border)
// Press "E" to enable interrupts (green border)
// Press "C" to enter pressed state (increaded BG_COLOR) - and "SPACE" to leave presssed state again.
// Holding SPACE will sometimes trigger the pressed state when normal interrupts are enabled (green border)
// but never when they are disabled (red border)
#include <keyboard.h>
#include <c64.h>

void main() {
    *BORDER_COLOR = GREEN;
    while(true) {
        menu();
    }
}

byte* SCREEN = $400;

void menu() {
    // Wait for key press
    while(true) {
        if(keyboard_key_pressed(KEY_C)!=0) {
            pressed();
            return;
        }
        if(keyboard_key_pressed(KEY_I)!=0) {
            *BORDER_COLOR = RED;
            asm { sei }
            return;
        }
        if(keyboard_key_pressed(KEY_E)!=0) {
            *BORDER_COLOR = GREEN;
            asm { cli }
            return;
        }
        (*SCREEN)++;
    }
}

void pressed() {
    (*BG_COLOR)++;
    // Wait for key press
    while(true) {
        if(keyboard_key_pressed(KEY_SPACE)!=0) {
            return;
        }
    }
}

