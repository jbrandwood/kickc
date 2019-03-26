// Draws a chess board in the upper left corner of the screen
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
    lda #$28
    clc
    adc screen
    sta screen
    bcc !+
    inc screen+1
  !:
    lda #$28
    clc
    adc colors
    sta colors
    bcc !+
    inc colors+1
  !:
    inc row
    lda #8
    cmp row
    bne b1
    rts
}
