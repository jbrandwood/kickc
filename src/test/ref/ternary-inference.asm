// Type inference into the ternary operator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  __b1:
    // i<5?0x57:'0'
    cpx #5
    bcc __b2
    lda #'0'
    jmp __b3
  __b2:
    lda #$57
  __b3:
    // (i<5?0x57:'0')+i
    stx.z $ff
    clc
    adc.z $ff
    // screen[i] = (i<5?0x57:'0')+i
    sta screen,x
    // for(byte i: 0..10)
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
