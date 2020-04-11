// Example showing how to perform linking using a linker-file
// The linker file is created using KickAssembler segments.
// See the KickAssembler manual for description of the format http://theweb.dk/KickAssembler/
// Specifying the linker script file is done using the #pragma link(<file>)
// It can also be specified using kickc command line option -T <file>

#pragma link("linking.ld")

char* BGCOL = 0xd021;

void main() {
    for(char i:0..255)
        base[i] = i;

    while(true) {
        fillscreen(*BGCOL);
        (*BGCOL)++;
    }
}

#pragma code_seg(CodeHigh)
#pragma data_seg(DataHigh)

char* SCREEN = 0x0400;

void fillscreen(char c) {
    char i = 0;
    for( char *screen = SCREEN; screen<SCREEN+1000; screen++)
        *screen = c+base[i++];
}

char base[256];

