// Test using some simple supported string escape
// Uses \xnn to add chars by hex-code

#pragma encoding(petscii_mixed)
char MSG1[] = "c\xc1mElot";

#pragma encoding(screencode_upper)
char MSG2[] = "C\x01M\x05LOT";

char CH = '\xde';

char* SCREEN1 = (char*)0x0400;
char* SCREEN2 = (char*)0x0428;

void main() {
    // Show mixed chars on screen
    *((char*)0xd018) = 0x17;

    char i=0;
    while(MSG1[i]) {
        chrout(MSG1[i]);
        SCREEN1[i] = MSG2[i];
        i++;
    }

    SCREEN2[0] = CH;

}

void chrout(char register(A) petscii) {
    kickasm(uses petscii, clobbers "") {{
        jsr $ffd2
    }}
}
