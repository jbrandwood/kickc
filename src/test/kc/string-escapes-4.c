// Test using some simple supported string escape
// Uses \xnn to add chars by hex-code

#pragma encoding(petscii_mixed)
char MSG1[] = "c\x41m\x45lot";

#pragma encoding(screencode_upper)
char MSG2[] = "C\x01M\x05LOT";

char CH = '\x10';

char* SCREEN1 = 0x0400;
char* SCREEN2 = 0x0428;
char* SCREEN3 = 0x0428;

void main() {
    // Show mixed chars on screen
    *((char*)0xd018) = 0x17;

    char i=0;
    while(MSG1[i]) {
        SCREEN1[i] = MSG1[i];
        SCREEN2[i] = MSG2[i];
        i++;
    }

    SCREEN3[0] = CH;

}
