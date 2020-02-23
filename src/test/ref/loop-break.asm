// Tests break statement in a simple loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // if(SCREEN[i]=='a')
    lda SCREEN,x
    cmp #'a'
    beq __breturn
    // SCREEN[i] = 'a'
    lda #'a'
    sta SCREEN,x
    // for( byte i: 0..40*6)
    inx
    cpx #$28*6+1
    bne __b1
  __breturn:
    // }
    rts
}
