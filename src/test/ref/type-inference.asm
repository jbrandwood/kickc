// Test inference of integer types in expressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label __0 = 2
    ldy #0
  __b1:
    // -0x30+b
    tya
    clc
    adc #-$30
    sta.z __0
    // screen[b] = -0x30+b
    tya
    asl
    tax
    lda.z __0
    sta screen,x
    lda #0
    sta screen+1,x
    // for( byte b: 0..20)
    iny
    cpy #$15
    bne __b1
    // }
    rts
}
