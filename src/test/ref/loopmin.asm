.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #0
    ldx #$a
  __b1:
    // if(i>5)
    cpx #5+1
    bcc __b2
    // s=s+i
    stx.z $ff
    clc
    adc.z $ff
  __b2:
    // i--;
    dex
    // while (i>0)
    cpx #0
    bne __b1
    // }
    rts
}
