  .label numpoints = 8
  jsr main
main: {
    lda #$1
    sta render.y
    ldy #$5
    lda #$0
    sta numpoints
    lda #$5
    jsr addpoint
    lda #$2
    sta render.y
    ldy #$8
    lda #$f
    jsr addpoint
    lda #$3
    sta render.y
    ldy #$e
    lda #$6
    jsr addpoint
    lda #$4
    sta render.y
    ldy #$2
    lda #$22
    jsr addpoint
    lda #$5
    sta render.y
    ldy #$11
    lda #$15
    jsr addpoint
    lda #$7
    sta render.y
    ldy #$16
    lda #$1f
    jsr addpoint
    jsr initscreen
  b1:
    jsr render
    jsr animate
    jmp b1
    rts
}
animate: {
    lda $1000
    clc
    adc #$1
    sta $1000
    lda $1000
    cmp #$28
    bne b1
    lda #$0
    sta $1000
  b1:
    lda $1100
    clc
    adc #$1
    sta $1100
    lda $1100
    cmp #$19
    bne b2
    lda #$0
    sta $1100
  b2:
    ldx $1001
    dex
    stx $1001
    lda $1001
    cmp #$ff
    bne b3
    lda #$28
    sta $1001
  b3:
    lda $1102
    clc
    adc #$1
    sta $1102
    lda $1102
    cmp #$19
    bne b4
    lda #$0
    sta $1102
  b4:
    ldx $1103
    dex
    stx $1103
    lda $1103
    cmp #$ff
    bne breturn
    lda #$19
    sta $1103
    lda $1003
    clc
    adc #$7
    sta $1003
    lda $1003
    cmp #$28
    bcc breturn
    lda $1003
    sec
    sbc #$28
    sta $1003
  breturn:
    rts
}
render: {
    .label x = 5
    .label colline = 3
    .label y = 2
    lda #<$d800
    sta colline
    lda #>$d800
    sta colline+$1
    lda #$0
    sta y
  b1:
    lda #$0
    sta x
  b2:
    lda x
    sta findcol.x
    lda y
    sta findcol.y
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
    inc colline+$1
  !:
    inc y
    lda y
    cmp #$19
    bne b1
    rts
}
findcol: {
    .label x = 9
    .label y = 10
    .label diff = 7
    .label yp = 11
    .label mindiff = 6
    ldy #$0
    lda #$ff
    sta mindiff
    ldx #$0
  b1:
    lda $1000,x
    sta diff
    lda $1100,x
    sta yp
    lda x
    cmp diff
    bne b2
    lda y
    cmp yp
    bne b2
    ldy #$0
  breturn:
    rts
  b2:
    lda x
    cmp diff
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
    ldy $1200,x
  b8:
    inx
    cpx numpoints
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
    .label colline = 3
    lda #<$400
    sta render.colline
    lda #>$400
    sta render.colline+$1
  b1:
    ldy #$0
    lda #$e6
    sta (render.colline),y
    inc render.colline
    bne !+
    inc render.colline+$1
  !:
    lda render.colline+$1
    cmp #>$7e8
    bcc b1
    bne !+
    lda render.colline
    cmp #<$7e8
    bcc b1
  !:
    rts
}
addpoint: {
    .label y = 2
    ldx numpoints
    sta $1000,x
    tya
    ldy numpoints
    sta $1100,y
    lda render.y
    ldx numpoints
    sta $1200,x
    inc numpoints
    rts
}
