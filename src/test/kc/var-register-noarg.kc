// Test declaring a variable as register with no information about which register (for compatibility with standard C)

#pragma encoding(screencode_upper)

char* SCREEN = 0x0400;
char MSG[] = "CAMELOT!";

void main() {
    register char i=0;
    while(i<40*4)
        SCREEN[i++] = MSG[i&7];
}
