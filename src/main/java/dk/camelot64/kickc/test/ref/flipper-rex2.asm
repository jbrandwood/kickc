  jsr main
main: {
    jsr prepare
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
    .label line = 2
    .label y = 4
    lda #$10
    sta y
    lda #<$4d4
    sta line
    lda #>$4d4
    sta line+$1
    ldx #$0
  b1:
    ldy #$0
  b2:
    lda $1000,x
    sta (line),y
    inx
    iny
    cpy #$10
    bcc b2
    lda line
    clc
    adc #$28
    sta line
    bcc !+
    inc line+$1
  !:
    dec y
    lda y
    bne b1
    rts
}
flip: {
    .label c = 5
    .label r = 4
    lda #$10
    sta r
    ldy #$f
    ldx #$0
  b1:
    lda #$10
    sta c
  b2:
    lda $1000,x
    sta $1100,y
    inx
    tya
    clc
    adc #$10
    tay
    dec c
    lda c
    bne b2
    dey
    dec r
    lda r
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
