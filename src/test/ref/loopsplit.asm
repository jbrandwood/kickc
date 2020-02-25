.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldy #0
    ldx #$64
  __b1:
    // while(--i>0)
    dex
    cpx #0
    bne __b2
    // *SCREEN = s
    sty SCREEN
    // }
    rts
  __b2:
    // if(i>50)
    cpx #$32+1
    bcs __b4
    // s--;
    dey
    jmp __b1
  __b4:
    // s++;
    iny
    jmp __b1
}
