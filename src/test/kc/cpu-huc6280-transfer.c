// Tests the HUC6280 instructions

#pragma cpu(huc6280)

void main() {
    char * const SCREEN = (char*)0x0400;
    asm {
    tia 1, 2, 3
    tdd $1000,$2000,$0800
    tii $1000+4*8,$2000+4*8,$0800+4*8
    tin SCREEN,$2000,40*24
    rts
    }
}
