// The screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label COLORS = $d800
  .const FILL = $e6
  // The total number of voronoi points
  .const numpoints = 6
main: {
    jsr initscreen
  b1:
    jsr render
    jsr animate
    jmp b1
}
animate: {
    ldx XPOS
    inx
    stx XPOS
    lda #$28
    cmp XPOS
    bne b1
    lda #0
    sta XPOS
  b1:
    ldx YPOS
    inx
    stx YPOS
    lda #$19
    cmp YPOS
    bne b2
    lda #0
    sta YPOS
  b2:
    lda XPOS+1
    sec
    sbc #1
    sta XPOS+1
    lda #$ff
    cmp XPOS+1
    bne b3
    lda #$28
    sta XPOS+1
  b3:
    lda YPOS+2
    clc
    adc #1
    sta YPOS+2
    lda #$19
    cmp YPOS+2
    bne b4
    lda #0
    sta YPOS+2
  b4:
    ldx YPOS+3
    dex
    stx YPOS+3
    lda #$ff
    cmp YPOS+3
    bne breturn
    lda #$19
    sta YPOS+3
    lda #7
    clc
    adc XPOS+3
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
    lda findcol.return
    ldy x
    sta (colline),y
    inc x
    lda #$28
    cmp x
    bne b2
    clc
    adc colline
    sta colline
    bcc !+
    inc colline+1
  !:
    inc y
    lda #$19
    cmp y
    bne b1
    rts
}
// findcol(byte zeropage(5) x, byte zeropage(2) y)
findcol: {
    .label x = 5
    .label y = 2
    .label yp = 8
    .label return = 7
    .label mincol = 7
    .label mindiff = 6
    lda #0
    sta mincol
    lda #$ff
    sta mindiff
    ldy #0
  b1:
    ldx XPOS,y
    lda YPOS,y
    sta yp
    cpx x
    bne b2
    lda y
    cmp yp
    bne b2
    lda #0
    sta return
  breturn:
    rts
  b2:
    txa
    cmp x
    beq !+
    bcs b4
  !:
    txa
    eor #$ff
    sec
    adc x
    tax
  b5:
    lda y
    cmp yp
    bcc b6
    sec
    sbc yp
    stx $ff
    clc
    adc $ff
    tax
  b7:
    cpx mindiff
    bcs b21
    lda COLS,y
    sta mincol
  b8:
    iny
    cpy #numpoints
    bcc b19
    jmp breturn
  b19:
    stx mindiff
    jmp b1
  b21:
    ldx mindiff
    jmp b8
  b6:
    lda yp
    sec
    sbc y
    stx $ff
    clc
    adc $ff
    tax
    jmp b7
  b4:
    txa
    sec
    sbc x
    tax
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
  // Points to create the Voronoi from
  XPOS: .byte 5, $f, 6, $22, $15, $1f
  YPOS: .byte 5, 8, $e, 2, $11, $16
  COLS: .byte 1, 2, 3, 4, 5, 7
