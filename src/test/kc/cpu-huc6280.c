// Tests the HUC6280 instructions

#pragma cpu(huc6280)

void main() {

    asm {
    sxy
    st0 #$55
    st1 #$aa
    sax
    st2 #$be
    say
    tma #2
    bsr !+
    tam #4
    csl
    cla
    clx
    cly
    csh
    set
!:
    rts
    }

}
