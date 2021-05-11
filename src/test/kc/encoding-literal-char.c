// Tests encoding of literal chars

#pragma encoding(petscii_mixed)
const char cpm = 'A';
const char spm[] = "A";
#pragma encoding(petscii_upper)
const char ccpu = 'A';
const char spu[] = "A";
#pragma encoding(screencode_mixed)
const char csm = 'A';
const char ssm[] = "A";
#pragma encoding(screencode_upper)
const char csu = 'A';
const char ssu[] = "A";

char* const screen = (char*)0x0400;
void main() {
    char idx = 0;
    screen[idx++] = cpm;
    screen[idx++] = ccpu;
    screen[idx++] = csm;
    screen[idx++] = csu;
    idx = 0x28;
    screen[idx++] = spm[0];
    screen[idx++] = spu[0];
    screen[idx++] = ssm[0];
    screen[idx++] = ssu[0];

}


