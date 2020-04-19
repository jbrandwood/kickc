// Tests casting pointer types to other pointer types does not produce any ASM code
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label bscreen = $400
    .label wscreen = bscreen
    ldx #0
  __b1:
    // wscreen[i] = (word)i
    txa
    asl
    tay
    txa
    sta wscreen,y
    lda #0
    sta wscreen+1,y
    // for(byte i: 0..2)
    inx
    cpx #3
    bne __b1
    // }
    rts
}
