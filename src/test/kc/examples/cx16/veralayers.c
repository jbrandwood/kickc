#include <printf.h>

void main() {

    textcolor(WHITE);
    backcolor(BLACK);
    clrscr();

    screenlayer(1);

    gotoxy(0,16);
    textcolor(GREEN);

    printf("this program demonstrates the layer functionality in text mode.\n");

    // Here we use the screensizex and screensizey functions to show the width and height of the text screen.
    printf("\nvera card width = %u; height = %u\n", screensizex(), screensizey());

    // This is the content of the main controller registers of the VERA of layer 1.
    // Layer 1 is the default layer that is activated in the CX16 at startup.
    // It displays the characters in 1BPP 16x16 color mode!
    printf("\nvera dc video = %x\n", *VERA_DC_VIDEO);
    printf("\nvera layer 1 config = %x\n", *VERA_L1_CONFIG);
    printf("vera layer 1 enabled = %x\n", screenlayerenabled(1));
    printf("vera layer 1 mapbase = %x, tilebase = %x\n", getscreenlayermapbase(1), *VERA_L1_TILEBASE);
    printf("vera layer 1 vscroll high = %x, low = %x\n", *VERA_L1_HSCROLL_H, *VERA_L1_HSCROLL_L);

    // Wait for a keypress and after clear the line!
    textcolor(YELLOW);
    printf("press a key");
    while(!kbhit());
    clearline();

    // Now we continue with demonstrating the layering!
    // We set the mapbase of layer 0 to an address in VRAM.
    // We copy the tilebase address from layer 1, so that we reference to the same tilebase.
    // We print a text on layer 0, which of course, won't yet be displayed,
    // because we haven't activated layer 0 on the VERA.
    // But the text will be printed and awaiting to be displayer later, once we activate layer 0!
    // But first, we also print the layer 0 VERA configuration.
    // This statement sets the base of the display layer 1 at VRAM address 0x0200

    setscreenlayermapbase(0,0x20); // Set the map base to address 0x04000
    *VERA_L0_CONFIG = *VERA_L1_CONFIG;
    *VERA_L0_TILEBASE = *VERA_L1_TILEBASE;


    printf("\nvera layer 0 config = %x\n", *VERA_L0_CONFIG);
    printf("vera layer 0 enabled = %x\n", screenlayerenabled(0));
    printf("vera layer 0 mapbase = %x, tilebase = %x\n", getscreenlayermapbase(0), *VERA_L0_TILEBASE);
    printf("vera layer 0 vscroll high = %x, low = %x\n", *VERA_L0_HSCROLL_H, *VERA_L0_HSCROLL_L);

    // Now we print the layer 0 text on the layer 0!
    screenlayer(0); // We set conio to output to layer 0 instead of layer 1!
    clrscr(); // We clear the screen of layer 0!
    textcolor(BLUE);
    backcolor(WHITE);
    gotoxy(19,4);
    printf("                                        ");
    gotoxy(19,5);
    printf("     this is printed on layer 0 !!!     ");
    gotoxy(19,6);
    printf("                                        ");

    gotoxy(0,40);

    screenlayer(1); // Now we ask conio again to output to layer 1!

    // Wait for a keypress and after clear the line!
    textcolor(YELLOW);
    backcolor(BLACK);
    printf("press a key to show layer 0 and show the text!");
    while(!kbhit());
    clearline();

    // Now we activate layer 0.
    screenlayerenable(0);

    // Wait for a keypress and after clear the line!
    textcolor(YELLOW);
    backcolor(BLACK);
    printf("press a key to hide layer 0 and hide the text again");
    while(!kbhit());
    clearline();

    screenlayerdisable(0);

    clrscr();
    textcolor(RED);
    backcolor(WHITE);
    gotoxy(19,10);
    printf("                                     ");
    gotoxy(19,11);
    printf("     analyze the code and learn!     ");
    gotoxy(19,12);
    printf("                                     ");
}
