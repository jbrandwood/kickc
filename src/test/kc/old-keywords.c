// Test that bytes and cycles are not keywords

char * const SCREEN = (char*)0x0400;

void main() {
    char cycles = 0;
    char bytes = 0;
    char uses = 0;
    char clobbers = 0;
    char resource = 0;
    char j=0;
    for(char i=0;i<20;i++) {
        SCREEN[j++] = cycles;
        SCREEN[j++] = bytes;
        SCREEN[j++] = uses;
        SCREEN[j++] = clobbers;
        SCREEN[j++] = resource;
        cycles +=1;
        bytes +=2;
        uses +=3;
        clobbers +=4;
        resource +=5;
    }

}