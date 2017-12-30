.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  .const COLORS = $d800
  .const FILL = $e6
  .const numpoints = 6
  jsr main
main: {
    jsr initscreen
  b1:
    jsr render
    jsr animate
    jmp b1
}
animate: {
    lda XPOS+0
    clc
    adc #1
    sta XPOS+0
    cmp #$28
    bne b1
    lda #0
    sta XPOS+0
  b1:
    lda YPOS+0
    clc
    adc #1
    sta YPOS+0
    cmp #$19
    bne b2
    lda #0
    sta YPOS+0
  b2:
    lda XPOS+1
    sec
    sbc #1
    sta XPOS+1
    cmp #$ff
    bne b3
    lda #$28
    sta XPOS+1
  b3:
    lda YPOS+2
    clc
    adc #1
    sta YPOS+2
    cmp #$19
    bne b4
    lda #0
    sta YPOS+2
  b4:
    lda YPOS+3
    sec
    sbc #1
    sta YPOS+3
    cmp #$ff
    bne breturn
    lda #$19
    sta YPOS+3
    lda XPOS+3
    clc
    adc #7
    sta XPOS+3
    cmp #$28
    bcc breturn
    sec
    sbc #$28
    sta XPOS+3
  breturn:
    rts
}
render: {
    .label x = 5
    .label colline = 3
    .label y = 2
    lda #<COLORS
    sta colline
    lda #>COLORS
    sta colline+1
    lda #0
    sta y
  b1:
    lda #0
    sta x
  b2:
    jsr findcol
    tya
    ldy x
    sta (colline),y
    inc x
    lda x
    cmp #$28
    bne b2
    lda colline
    clc
    adc #$28
    sta colline
    bcc !+
    inc colline+1
  !:
    inc y
    lda y
    cmp #$19
    bne b1
    rts
}
findcol: {
    .label x = 5
    .label y = 2
    .label xp = 7
    .label yp = 8
    .label diff = 7
    .label mindiff = 6
    ldy #0
    lda #$ff
    sta mindiff
    ldx #0
  b1:
    lda XPOS,x
    sta xp
    lda YPOS,x
    sta yp
    lda x
    cmp xp
    bne b2
    lda y
    cmp yp
    bne b2
    ldy #0
  breturn:
    rts
  b2:
    lda x
    cmp xp
    bcs b4
    lda diff
    sec
    sbc x
    sta diff
  b5:
    lda y
    cmp yp
    bcs b6
    lda yp
    sec
    sbc y
    clc
    adc diff
  b7:
    cmp mindiff
    bcs b21
    ldy COLS,x
  b8:
    inx
    cpx #numpoints
    bcc b19
    jmp breturn
  b19:
    sta mindiff
    jmp b1
  b21:
    lda mindiff
    jmp b8
  b6:
    lda y
    sec
    sbc yp
    clc
    adc diff
    jmp b7
  b4:
    lda x
    sec
    sbc diff
    sta diff
    jmp b5
}
initscreen: {
    .label screen = 3
    lda #<SCREEN
    sta screen
    lda #>SCREEN
    sta screen+1
  b1:
    lda #FILL
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    lda screen+1
    cmp #>SCREEN+$3e8
    bcc b1
    bne !+
    lda screen
    cmp #<SCREEN+$3e8
    bcc b1
  !:
    rts
}
  XPOS: .byte 5, $f, 6, $22, $15, $1f
  YPOS: .byte 5, 8, $e, 2, $11, $16
  COLS: .byte 1, 2, 3, 4, 5, 7
