  jsr main
main: {
    lda #$1
    sta $2
    ldy #$5
    lda #$0
    sta $8
    lda #$5
    jsr addpoint
    lda #$2
    sta $2
    ldy #$8
    lda #$f
    jsr addpoint
    lda #$3
    sta $2
    ldy #$e
    lda #$6
    jsr addpoint
    lda #$4
    sta $2
    ldy #$2
    lda #$22
    jsr addpoint
    lda #$5
    sta $2
    ldy #$11
    lda #$15
    jsr addpoint
    lda #$7
    sta $2
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
    lda #<$d800
    sta $3
    lda #>$d800
    sta $3+$1
    lda #$0
    sta $2
  b1:
    lda #$0
    sta $5
  b2:
    lda $5
    sta $9
    lda $2
    sta $a
    jsr findcol
    tya
    ldy $5
    sta ($3),y
    inc $5
    lda $5
    cmp #$28
    bne b2
    lda $3
    clc
    adc #$28
    sta $3
    bcc !+
    inc $3+$1
  !:
    inc $2
    lda $2
    cmp #$19
    bne b1
    rts
}
findcol: {
    ldy #$0
    lda #$ff
    sta $6
    ldx #$0
  b1:
    lda $1000,x
    sta $7
    lda $1100,x
    sta $b
    lda $9
    cmp $7
    bne b2
    lda $a
    cmp $b
    bne b2
    ldy #$0
  breturn:
    rts
  b2:
    lda $9
    cmp $7
    bcs b4
    lda $7
    sec
    sbc $9
    sta $7
  b5:
    lda $a
    cmp $b
    bcs b6
    lda $b
    sec
    sbc $a
    clc
    adc $7
  b7:
    cmp $6
    bcs b21
    ldy $1200,x
  b8:
    inx
    cpx $8
    bcc b19
    jmp breturn
  b19:
    sta $6
    jmp b1
  b21:
    lda $6
    jmp b8
  b6:
    lda $a
    sec
    sbc $b
    clc
    adc $7
    jmp b7
  b4:
    lda $9
    sec
    sbc $7
    sta $7
    jmp b5
}
initscreen: {
    lda #<$400
    sta $3
    lda #>$400
    sta $3+$1
  b1:
    ldy #$0
    lda #$e6
    sta ($3),y
    inc $3
    bne !+
    inc $3+$1
  !:
    lda $3+$1
    cmp #>$7e8
    bcc b1
    bne !+
    lda $3
    cmp #<$7e8
    bcc b1
  !:
    rts
}
addpoint: {
    ldx $8
    sta $1000,x
    tya
    ldy $8
    sta $1100,y
    lda $2
    ldx $8
    sta $1200,x
    inc $8
    rts
}
