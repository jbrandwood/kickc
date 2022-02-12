// Tests the HUC6280 instructions

#pragma cpu(huc6280)

void main() {
    asm {
    tst #1+2,$3+4
    tst #1+2*3,$7654/2
    tst #1+2,$3+4,x
    tst #1+2*3,$7654/2,x
!:
    rts
    }
}
