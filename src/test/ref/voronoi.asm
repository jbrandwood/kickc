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
    .label x = 3
    .label colline = 6
    .label y = 2
    lda #<COLORS
    sta.z colline
    lda #>COLORS
    sta.z colline+1
    lda #0
    sta.z y
  b1:
    lda #0
    sta.z x
  b2:
    jsr findcol
    lda.z findcol.return
    ldy.z x
    sta (colline),y
    inc.z x
    lda #$28
    cmp.z x
    bne b2
    clc
    adc.z colline
    sta.z colline
    bcc !+
    inc.z colline+1
  !:
    inc.z y
    lda #$19
    cmp.z y
    bne b1
    rts
}
// findcol(byte zeropage(3) x, byte zeropage(2) y)
findcol: {
    .label x = 3
    .label y = 2
    .label yp = 8
    .label return = 5
    .label mincol = 5
    .label mindiff = 4
    lda #$ff
    sta.z mindiff
    lda #0
    sta.z mincol
    tay
  b2:
    ldx XPOS,y
    lda YPOS,y
    sta.z yp
    cpx.z x
    bne b3
    lda.z y
    cmp.z yp
    bne b3
    lda #0
    sta.z return
    rts
  b3:
    txa
    cmp.z x
    beq !+
    bcs b4
  !:
    txa
    eor #$ff
    sec
    adc.z x
    tax
  b5:
    lda.z y
    cmp.z yp
    bcc b6
    sec
    sbc.z yp
    stx.z $ff
    clc
    adc.z $ff
    tax
  b7:
    cpx.z mindiff
    bcs b14
    lda COLS,y
    sta.z mincol
  b8:
    iny
    cpy #numpoints
    bcc b13
    rts
  b13:
    stx.z mindiff
    jmp b2
  b14:
    ldx.z mindiff
    jmp b8
  b6:
    lda.z yp
    sec
    sbc.z y
    stx.z $ff
    clc
    adc.z $ff
    tax
    jmp b7
  b4:
    txa
    sec
    sbc.z x
    tax
    jmp b5
}
initscreen: {
    .label screen = 6
    lda #<SCREEN
    sta.z screen
    lda #>SCREEN
    sta.z screen+1
  b2:
    lda #FILL
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    lda.z screen+1
    cmp #>SCREEN+$3e8
    bcc b2
    bne !+
    lda.z screen
    cmp #<SCREEN+$3e8
    bcc b2
  !:
    rts
}
  // Points to create the Voronoi from
  XPOS: .byte 5, $f, 6, $22, $15, $1f
  YPOS: .byte 5, 8, $e, 2, $11, $16
  COLS: .byte 1, 2, 3, 4, 5, 7
