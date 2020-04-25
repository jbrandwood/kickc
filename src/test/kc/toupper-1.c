// Test toupper()

#include <conio.h>
#include <ctype.h>

void main() {
    // Show mixed chars on screen
    *((char*)0xd018) = 0x17;
    // Clear screen
    clrscr();
    // Output un-modified chars
    for(char c:0..0xff) {
        cputc(c);
    }
    gotoxy(0, wherey()+2);
    // Output toupper-chars chars
    for(char c:0..0xff) {
        cputc(toupper(c));
    }
}