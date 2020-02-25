// Tests break statement in a simple loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // if(SCREEN[i]==' ')
    lda SCREEN,x
    cmp #' '
    beq __b3
    // SCREEN[i]++;
    inc SCREEN,x
  __b3:
    // for( byte i: 0..40*6)
    inx
    cpx #$28*6+1
    bne __b1
    // }
    rts
}
