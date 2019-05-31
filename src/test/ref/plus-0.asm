// Tests elimination of plus 0
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #'a'
    lda #<$400
    sta fill.screen
    lda #>$400
    sta fill.screen+1
    jsr fill
    ldx #'b'
    lda #<$2000
    sta fill.screen
    lda #>$2000
    sta fill.screen+1
    jsr fill
    rts
}
// fill(byte* zeropage(2) screen, byte register(X) ch)
fill: {
    .label screen = 2
    .label _5 = 4
    .label _7 = 6
    ldy #0
  b2:
    txa
    sta (screen),y
    lda #1*$28
    clc
    adc screen
    sta _5
    lda #0
    adc screen+1
    sta _5+1
    txa
    sta (_5),y
    lda #2*$28
    clc
    adc screen
    sta _7
    lda #0
    adc screen+1
    sta _7+1
    txa
    sta (_7),y
    iny
    cpy #$28
    bne b2
    rts
}
