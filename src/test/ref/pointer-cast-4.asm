// Tests casting pointer types to other pointer types does not produce any ASM code
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label bscreen = $400
    .label wscreen = bscreen
    .label __1 = 2
    ldx #0
  __b1:
    // (word)i
    txa
    sta.z __1
    lda #0
    sta.z __1+1
    // wscreen[i] = (word)i
    txa
    asl
    tay
    lda.z __1
    sta wscreen,y
    lda.z __1+1
    sta wscreen+1,y
    // for(byte i: 0..2)
    inx
    cpx #3
    bne __b1
    // }
    rts
}
