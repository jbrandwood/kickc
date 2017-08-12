  jsr main
main: {
    jsr prepare
    ldx #$19
    jmp b3
  b3_from_b11:
    ldx #$19
  b3:
    lda $d012
    cmp #$fe
    bne b3
  b4:
    lda $d012
    cmp #$ff
    bne b4
    dex
    cpx #$0
    bne b3
    jsr flip
    jsr plot
    jmp b3_from_b11
    rts
}
plot: {
    lda #$10
    sta $4
    lda #<$4d4
    sta $2
    lda #>$4d4
    sta $2+$1
    ldx #$0
  b1:
    ldy #$0
  b2:
    lda $1000,x
    sta ($2),y
    inx
    iny
    cpy #$10
    bcc b2
    lda $2
    clc
    adc #$28
    sta $2
    bcc !+
    inc $2+$1
  !:
    dec $4
    lda $4
    bne b1
    rts
}
flip: {
    lda #$10
    sta $4
    ldy #$f
    ldx #$0
  b1:
    lda #$10
    sta $5
  b2:
    lda $1000,x
    sta $1100,y
    inx
    tya
    clc
    adc #$10
    tay
    dec $5
    lda $5
    bne b2
    dey
    dec $4
    lda $4
    bne b1
    ldx #$0
  b3:
    lda $1100,x
    sta $1000,x
    inx
    cpx #$0
    bne b3
    rts
}
prepare: {
    ldx #$0
  b1:
    txa
    sta $1000,x
    inx
    cpx #$0
    bne b1
    rts
}
