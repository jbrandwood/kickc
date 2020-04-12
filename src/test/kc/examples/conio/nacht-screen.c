// Show a nice screen using conio.h
// From CC65 sample "Eine kleine Nachtmusik" by Ullrich von Bassewitz
// https://github.com/cc65/cc65/blob/master/samples/nachtm.c

#include <conio.h>
#include <string.h>

const char COLOR_GRAY3 = 0x0f;
const char COLOR_BLACK = 0x00;
char * const VIC_MEMORY = 0xd018;

static unsigned char XSize, YSize;

void main() {
    *VIC_MEMORY = 0x17;
    screensize(&XSize, &YSize);
    MakeNiceScreen();
    while(!kbhit()) {}
    clrscr ();
}

void MakeTeeLine (unsigned char Y)
/* Make a divider line */
{
    cputcxy (0, Y, CH_LTEE);
    chline (XSize - 2);
    cputc (CH_RTEE);
}

typedef struct {
        unsigned char   Y;
        char         Msg[40];
    } TextDesc;

void MakeNiceScreen (void)
/* Make a nice screen */
{

    static TextDesc Text [] = {
        {   2, "Wolfgang Amadeus Mozart"        },
        {   4, "\"Eine kleine Nachtmusik\""     },
        {   5, "(KV 525)"                       },
        {   9, "Ported to the SID in 1987 by" },
        {  11, "Joachim von Bassewitz"          },
        {  12, "(joachim@von-bassewitz.de)"     },
        {  13, "and"                            },
        {  14, "Ullrich von Bassewitz"          },
        {  15, "(ullrich@von-bassewitz.de)"     },
        {  18, "C Implementation by"            },
        {  19, "Ullrich von Bassewitz"          },
        {  23, "Press any key to quit..."       }
    };

    register const TextDesc* T;
    unsigned char I;
    unsigned char X;

    /* Clear the screen hide the cursor, set colors */
    textcolor (COLOR_GRAY3);
    bordercolor (COLOR_BLACK);
    bgcolor (COLOR_BLACK);
    clrscr ();
    cursor (0);

    /* Top line */
    cputcxy (0, 0, CH_ULCORNER);
    chline (XSize - 2);
    cputc (CH_URCORNER);

    /* Left line */
    cvlinexy (0, 1, 23);

    /* Bottom line */
    cputc (CH_LLCORNER);
    chline (XSize - 2);
    cputc (CH_LRCORNER);

    /* Right line */
    cvlinexy (XSize - 1, 1, 23);

    /* Several divider lines */
    MakeTeeLine (7);
    MakeTeeLine (22);

    /* Write something into the frame */
    for (I = 0, T = Text; I < sizeof (Text) / sizeof (TextDesc); ++I) {
        X = (XSize - (char)strlen (T->Msg)) >> 1;
        cputsxy (X, T->Y, T->Msg);
        ++T;
    }

}