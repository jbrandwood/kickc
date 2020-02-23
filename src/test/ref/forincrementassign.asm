// Classic for() does not allow assignment as increment, eg. for(byte i=0;i<40;i=i+2) {}
// The following should give a program rendering a char on every second char of the first line - but results in a syntax error
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #0
  __b1:
    // for(byte i=0;i<40;i=i+2)
    cmp #$28
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = i
    tax
    sta SCREEN,x
    // i=i+2
    clc
    adc #2
    jmp __b1
}
