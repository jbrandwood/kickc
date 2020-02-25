// Draws a chess board in the upper left corner of the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    .label colors = 4
    .label row = 6
    lda #0
    sta.z row
    lda #<$d800
    sta.z colors
    lda #>$d800
    sta.z colors+1
    ldx #1
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
  __b1:
    ldy #0
  __b2:
    // screen[column] = $a0
    lda #$a0
    sta (screen),y
    // colors[column] = color
    txa
    sta (colors),y
    // color = color^1
    txa
    eor #1
    tax
    // for( byte column: 0..7)
    iny
    cpy #8
    bne __b2
    // color = color^1
    txa
    eor #1
    tax
    // screen = screen+40
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    // colors = colors+40
    lda #$28
    clc
    adc.z colors
    sta.z colors
    bcc !+
    inc.z colors+1
  !:
    // for( byte row: 0..7)
    inc.z row
    lda #8
    cmp.z row
    bne __b1
    // }
    rts
}
