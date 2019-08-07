// Classic for() does not allow assignment as increment, eg. for(byte i=0;i<40;i=i+2) {}
// The following should give a program rendering a char on every second char of the first line - but results in a syntax error
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #0
  b2:
    tax
    sta SCREEN,x
    clc
    adc #2
    cmp #$28
    bcc b2
    rts
}
