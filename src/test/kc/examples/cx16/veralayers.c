#include <printf.h>

void main() {
    textcolor(BLUE);
    backcolor(BLACK);
    clrscr();
    // This statement sets the base of the display layer 1 at VRAM address 0x0200
    setscreenlayermapbase(0,0x20);
    screenlayer(0);
    clrscr();
    screenlayer(1);

    gotoxy(0,0);

    gotoxy(0,16);
    textcolor(RED);
    unsigned int width = screensizex();
    unsigned int height = screensizey();
    printf("vera card width = %u; height = %u\n", width, height);

    printf("dc video = %x\n", *VERA_DC_VIDEO);
    printf("vera card layer 0 enabled = %x\n", screenlayerenabled(0));
    printf("vera card mapbase layer 0 = %x\n", getscreenlayermapbase(0));
    printf("l0 config = %x\n", *VERA_L0_CONFIG);
    printf("l0 tilebase = %x\n", *VERA_L0_TILEBASE);
    printf("l0 vscroll l = %x\n", *VERA_L0_HSCROLL_L);
    printf("l0 vscroll h = %x\n", *VERA_L0_HSCROLL_H);
    printf("vera card layer 1 enabled = %x\n", screenlayerenabled(1));
    printf("vera card mapbase layer 1 = %x\n", getscreenlayermapbase(1));
    printf("l1 config = %x\n", *VERA_L1_CONFIG);
    printf("l1 tilebase = %x\n", *VERA_L1_TILEBASE);
    printf("l1 vscroll l = %x\n", *VERA_L1_HSCROLL_L);
    printf("l1 vscroll h = %x\n", *VERA_L1_HSCROLL_H);

    textcolor(BLUE);
    //disablescreenlayer1();
    screenlayerenable(0);
    printf("dc video = %x\n", *VERA_DC_VIDEO);
    printf("vera card layer 0 enabled = %x\n", screenlayerenabled(0));
    printf("vera card layer 1 enabled = %x\n", screenlayerenabled(1));
    printf("vera card mapbase layer 0 = %x\n", getscreenlayermapbase(0));
    printf("vera card mapbase layer 1 = %x\n", getscreenlayermapbase(1));
    printf("vera card mapbase layer 1 = %x\n", getscreenlayermapbase(1));

    screenlayer(0);
    gotoxy(0,0);
    textcolor(GREEN);
    *VERA_L0_CONFIG = *VERA_L1_CONFIG;
    *VERA_L0_TILEBASE = *VERA_L1_TILEBASE;
    printf("this is printed on layer 0");

    //screenlayerdisable(0);
}
