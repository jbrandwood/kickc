// The screen
  // Commodore 64 PRG executable file
.file [name="voronoi.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const FILL = $e6
  // The total number of voronoi points
  .const numpoints = 6
  .label SCREEN = $400
  .label COLORS = $d800
.segment Code
main: {
    // initscreen()
    jsr initscreen
  __b1:
    // render()
    jsr render
    // animate()
    jsr animate
    jmp __b1
}
initscreen: {
    .label screen = 3
    lda #<SCREEN
    sta.z screen
    lda #>SCREEN
    sta.z screen+1
  __b1:
    // for( byte* screen = SCREEN; screen<SCREEN+$03e8; ++screen)
    lda.z screen+1
    cmp #>SCREEN+$3e8
    bcc __b2
    bne !+
    lda.z screen
    cmp #<SCREEN+$3e8
    bcc __b2
  !:
    // }
    rts
  __b2:
    // *screen = FILL
    lda #FILL
    ldy #0
    sta (screen),y
    // for( byte* screen = SCREEN; screen<SCREEN+$03e8; ++screen)
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    jmp __b1
}
render: {
    .label x = 5
    .label colline = 3
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
    // findcol(x, y)
    jsr findcol
    // findcol(x, y)
    txa
    // byte col = findcol(x, y)
    // colline[x] = col
    ldy.z x
    sta (colline),y
    // for( byte x : 0..39)
    inc.z x
    lda #$28
    cmp.z x
    bne __b2
    // colline = colline+40
    clc
    adc.z colline
    sta.z colline
    bcc !+
    inc.z colline+1
  !:
    // for( byte y : 0.. 24)
    inc.z y
    lda #$19
    cmp.z y
    bne __b1
    // }
    rts
}
animate: {
    // XPOS[0]+1
    ldx XPOS
    inx
    // XPOS[0] = XPOS[0]+1
    stx XPOS
    // if(XPOS[0]==40)
    lda #$28
    cmp XPOS
    bne __b1
    // XPOS[0] = 0
    lda #0
    sta XPOS
  __b1:
    // YPOS[0]+1
    ldx YPOS
    inx
    // YPOS[0] = YPOS[0]+1
    stx YPOS
    // if(YPOS[0]==25)
    lda #$19
    cmp YPOS
    bne __b2
    // YPOS[0] = 0
    lda #0
    sta YPOS
  __b2:
    // XPOS[1]-1
    lda XPOS+1
    sec
    sbc #1
    // XPOS[1] = XPOS[1]-1
    sta XPOS+1
    // if(XPOS[1]==255)
    lda #$ff
    cmp XPOS+1
    bne __b3
    // XPOS[1] = 40
    lda #$28
    sta XPOS+1
  __b3:
    // YPOS[2]+1
    lda YPOS+2
    clc
    adc #1
    // YPOS[2] = YPOS[2]+1
    sta YPOS+2
    // if(YPOS[2]==25)
    lda #$19
    cmp YPOS+2
    bne __b4
    // YPOS[2] = 0
    lda #0
    sta YPOS+2
  __b4:
    // YPOS[3]-1
    ldx YPOS+3
    dex
    // YPOS[3] = YPOS[3]-1
    stx YPOS+3
    // if(YPOS[3]==255)
    lda #$ff
    cmp YPOS+3
    bne __breturn
    // YPOS[3] = 25
    lda #$19
    sta YPOS+3
    // XPOS[3]+7
    lax XPOS+3
    axs #-[7]
    // XPOS[3] = XPOS[3]+7
    stx XPOS+3
    // if(XPOS[3]>=40)
    txa
    cmp #$28
    bcc __breturn
    // XPOS[3]-40
    lax XPOS+3
    axs #$28
    // XPOS[3] = XPOS[3]-40
    stx XPOS+3
  __breturn:
    // }
    rts
}
// findcol(byte zp(5) x, byte zp(2) y)
findcol: {
    .label x = 5
    .label y = 2
    .label xp = 8
    .label yp = 9
    .label i = 6
    .label mindiff = 7
    lda #$ff
    sta.z mindiff
    ldx #0
    txa
    sta.z i
  __b1:
    // for( byte i=0; i<numpoints; ++i)
    lda.z i
    cmp #numpoints
    bcc __b2
    // }
    rts
  __b2:
    // byte xp = XPOS[i]
    ldy.z i
    lda XPOS,y
    sta.z xp
    // byte yp = YPOS[i]
    lda YPOS,y
    sta.z yp
    // if(x==xp)
    lda.z x
    cmp.z xp
    bne __b3
    // if(y==yp)
    lda.z y
    cmp.z yp
    bne __b3
    ldx #0
    rts
  __b3:
    // if(x<xp)
    lda.z x
    cmp.z xp
    bcc __b4
    // diff = x-xp
    sec
    sbc.z xp
    tay
  __b5:
    // if(y<yp)
    lda.z y
    cmp.z yp
    bcc __b6
    // y-yp
    sec
    sbc.z yp
    // diff = diff + (y-yp)
    sty.z $ff
    clc
    adc.z $ff
  __b7:
    // if(diff<mindiff)
    cmp.z mindiff
    bcs __b13
    // mincol = COLS[i]
    ldy.z i
    ldx COLS,y
  __b8:
    // for( byte i=0; i<numpoints; ++i)
    inc.z i
    sta.z mindiff
    jmp __b1
  __b13:
    lda.z mindiff
    jmp __b8
  __b6:
    // yp-y
    lda.z yp
    sec
    sbc.z y
    // diff = diff + (yp-y)
    sty.z $ff
    clc
    adc.z $ff
    jmp __b7
  __b4:
    // diff = xp-x
    lda.z xp
    sec
    sbc.z x
    tay
    jmp __b5
}
.segment Data
  // Points to create the Voronoi from
  XPOS: .byte 5, $f, 6, $22, $15, $1f
  YPOS: .byte 5, 8, $e, 2, $11, $16
  COLS: .byte 1, 2, 3, 4, 5, 7
