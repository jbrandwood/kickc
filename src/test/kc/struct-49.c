// Structs with char* pointer members
// https://gitlab.com/camelot/kickc/-/issues/397

typedef struct {
    unsigned char   Y;
    char         *Msg;
} TextDesc;

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

void main() {
    char * screen = (char*)0x0400;
    TextDesc *txt = Text;
    for(char i=0;i<sizeof(Text)/sizeof(TextDesc); i++, txt++) {
        for(char* msg = txt->Msg; *msg; msg++)
            *(screen++) = *msg;
        *(screen++) = ' ';
    }
}

