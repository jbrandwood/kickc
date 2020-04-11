/* Textbox routine with word wrap for KickC by Scan/Desire */
#include <c64.h>

byte* const screen = $0400;
const byte text[] = "this is a small test with word wrap, if a word is too long it moves it to the next line. isn't that supercalifragilisticexpialidocious? i think it's cool!";
const byte text2[] = "textbox by scan of desire";

void main() {
    for (byte x = 0; x < 15; x += 2) {
        textbox(x,x,x+x+1,x+10,text2);
        for (word wait = 0; wait < 35000; wait++) {}
    }
    textbox(0,12,20,24,text);
    textbox(3,3,37,9,text);
    textbox(30,8,39,24,text);
    do {} while (true);
}

void textbox(byte x1, byte y1, byte x2, byte y2, byte* text) {
    draw_window(x1, y1, x2, y2);
    byte y = y1+1;
    byte x = x1+1;
   	word z = (word)y*40;
    byte i = 0;
    if (x == x2 || y == y2) {
        // no room to draw text, simply return
        return;
    }
    do {
        screen[z+x] = text[i];
        if (text[i] == $20) {
            // scan ahead to determine next word length
            byte c = 0;
            byte ls = i+1;
            while (text[ls] != $20 && text[ls] != $00) {
                ls++;
                c++;
            }
            // if it's too big to fit but not bigger than the whole box width, move to next line
            if (c+x >= x2 && c < x2-x1) {
              x = x1;
              y++;
              if (y == y2) {
                  // text too long for textbox
                  return;
              }
              z = y*40;
            }
        }
        i++;
        x++;
        // this is in case the word is too long for one line and needs to be cut
        if (x == x2) {
            x = x1+1;
            y++;
            if (y == y2) {
                // text too long for textbox
                return;
            }
            z = y*40;
        }
    } while (text[i] != 0);
}

void draw_window(byte x1, byte y1, byte x2, byte y2) {
   	word z = y1*40;
    word q = y2*40;

    // draw horizontal lines
    for (byte x = x1+1; x < x2; x++) {
        screen[z+x] = $43;
        screen[q+x] = $43;
    }

    // draw upper corners
    screen[z+x1] = $55;
    screen[z+x2] = $49;

    // draw vertical lines
    for (byte y = y1+1; y < y2; y++) {
       	z = y*40;
        screen[z+x1] = $42;
        screen[z+x2] = $42;
    }

    // draw lower corners
    screen[q+x1] = $4a;
    screen[q+x2] = $4b;

    // window big enough to have an inside?
    if (x2-x1 > 1 && y2-y1 > 1) {
        // blank inside
        for(byte y = y1+1; y < y2; y++) {
            z = y*40;
            for(byte x = x1+1; x < x2; x++) {
                screen[z+x] = $20;
           }
        }
    }
}
