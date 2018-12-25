.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    .label colors = 4
    .label row = 6
    lda #0
    sta row
    lda #<$d800
    sta colors
    lda #>$d800
    sta colors+1
    ldx #1
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
  b1:
    ldy #0
  b2:
    lda #$a0
    sta (screen),y
    txa
    sta (colors),y
    txa
    eor #1
    tax
    iny
    cpy #8
    bne b2
    txa
    eor #1
    tax
    lda screen
    clc
    adc #$28
    sta screen
    bcc !+
    inc screen+1
  !:
    lda colors
    clc
    adc #$28
    sta colors
    bcc !+
    inc colors+1
  !:
    inc row
    lda row
    cmp #8
    bne b1
    rts
}
