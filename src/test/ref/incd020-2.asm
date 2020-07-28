.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
  __b1:
    // (*(unsigned char *)(53280))++;
    inc $d020
    // while ( (*(unsigned char *)(53280)) < 255)
    lda $d020
    cmp #$ff
    bcc __b1
    // }
    rts
}
