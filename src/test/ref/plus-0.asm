// Tests elimination of plus 0
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #'a'
    lda #<$400
    sta.z fill.screen
    lda #>$400
    sta.z fill.screen+1
    jsr fill
    ldx #'b'
    lda #<$2000
    sta.z fill.screen
    lda #>$2000
    sta.z fill.screen+1
    jsr fill
    rts
}
// fill(byte* zp(2) screen, byte register(X) ch)
fill: {
    .label screen = 2
    .label __5 = 4
    .label __7 = 6
    ldy #0
  __b2:
    txa
    sta (screen),y
    lda #1*$28
    clc
    adc.z screen
    sta.z __5
    lda #0
    adc.z screen+1
    sta.z __5+1
    txa
    sta (__5),y
    lda #2*$28
    clc
    adc.z screen
    sta.z __7
    lda #0
    adc.z screen+1
    sta.z __7+1
    txa
    sta (__7),y
    iny
    cpy #$28
    bne __b2
    rts
}
