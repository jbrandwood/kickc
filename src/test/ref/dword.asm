.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const a = $ee6b2800
    .label SCREEN = $400
    .label b = 2
    ldx #0
  __b1:
    // b = a + i
    txa
    clc
    adc #<a
    sta.z b
    lda #>a
    adc #0
    sta.z b+1
    lda #<a>>$10
    adc #0
    sta.z b+2
    lda #>a>>$10
    adc #0
    sta.z b+3
    // c = (byte) b
    lda.z b
    // SCREEN[i] = c
    sta SCREEN,x
    // for( byte i: 0..100)
    inx
    cpx #$65
    bne __b1
    // }
    rts
}
