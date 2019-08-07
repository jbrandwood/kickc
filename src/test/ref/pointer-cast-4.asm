// Tests casting pointer types to other pointer types does not produce any ASM code
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label bscreen = $400
    .label wscreen = bscreen
    .label _1 = 2
    ldx #0
  b1:
    txa
    sta.z _1
    lda #0
    sta.z _1+1
    txa
    asl
    tay
    lda.z _1
    sta wscreen,y
    lda.z _1+1
    sta wscreen+1,y
    inx
    cpx #3
    bne b1
    rts
}
