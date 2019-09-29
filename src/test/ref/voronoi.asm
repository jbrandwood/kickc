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
  __b1:
    jsr render
    jsr animate
    jmp __b1
}
animate: {
    ldx XPOS
    inx
    stx XPOS
    lda #$28
    cmp XPOS
    bne __b1
    lda #0
    sta XPOS
  __b1:
    ldx YPOS
    inx
    stx YPOS
    lda #$19
    cmp YPOS
    bne __b2
    lda #0
    sta YPOS
  __b2:
    lda XPOS+1
    sec
    sbc #1
    sta XPOS+1
    lda #$ff
    cmp XPOS+1
    bne __b3
    lda #$28
    sta XPOS+1
  __b3:
    lda YPOS+2
    clc
    adc #1
    sta YPOS+2
    lda #$19
    cmp YPOS+2
    bne __b4
    lda #0
    sta YPOS+2
  __b4:
    ldx YPOS+3
    dex
    stx YPOS+3
    lda #$ff
    cmp YPOS+3
    bne __breturn
    lda #$19
    sta YPOS+3
    lda #7
    clc
    adc XPOS+3
    sta XPOS+3
    cmp #$28
    bcc __breturn
    sec
    sbc #$28
    sta XPOS+3
  __breturn:
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
  __b1:
    lda #0
    sta.z x
  __b2:
    jsr findcol
    txa
    ldy.z x
    sta (colline),y
    inc.z x
    lda #$28
    cmp.z x
    bne __b2
    clc
    adc.z colline
    sta.z colline
    bcc !+
    inc.z colline+1
  !:
    inc.z y
    lda #$19
    cmp.z y
    bne __b1
    rts
}
// findcol(byte zeropage(3) x, byte zeropage(2) y)
findcol: {
    .label x = 3
    .label y = 2
    .label xp = 8
    .label yp = 9
    .label i = 4
    .label mindiff = 5
    lda #$ff
    sta.z mindiff
    ldx #0
    txa
    sta.z i
  __b1:
    lda.z i
    cmp #numpoints
    bcc __b2
    rts
  __b2:
    ldy.z i
    lda XPOS,y
    sta.z xp
    lda YPOS,y
    sta.z yp
    lda.z x
    cmp.z xp
    bne __b3
    lda.z y
    cmp.z yp
    bne __b3
    ldx #0
    rts
  __b3:
    lda.z x
    cmp.z xp
    bcc __b4
    sec
    sbc.z xp
    tay
  __b5:
    lda.z y
    cmp.z yp
    bcc __b6
    sec
    sbc.z yp
    sty.z $ff
    clc
    adc.z $ff
  __b7:
    cmp.z mindiff
    bcs __b13
    ldy.z i
    ldx COLS,y
  __b8:
    inc.z i
    sta.z mindiff
    jmp __b1
  __b13:
    lda.z mindiff
    jmp __b8
  __b6:
    lda.z yp
    sec
    sbc.z y
    sty.z $ff
    clc
    adc.z $ff
    jmp __b7
  __b4:
    lda.z xp
    sec
    sbc.z x
    tay
    jmp __b5
}
initscreen: {
    .label screen = 6
    lda #<SCREEN
    sta.z screen
    lda #>SCREEN
    sta.z screen+1
  __b1:
    lda.z screen+1
    cmp #>SCREEN+$3e8
    bcc __b2
    bne !+
    lda.z screen
    cmp #<SCREEN+$3e8
    bcc __b2
  !:
    rts
  __b2:
    lda #FILL
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    jmp __b1
}
  // Points to create the Voronoi from
  XPOS: .byte 5, $f, 6, $22, $15, $1f
  YPOS: .byte 5, 8, $e, 2, $11, $16
  COLS: .byte 1, 2, 3, 4, 5, 7
