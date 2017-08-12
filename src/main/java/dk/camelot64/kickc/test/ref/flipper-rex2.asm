bbegin:
  jsr main
bend:
main: {
    jsr prepare
  b3_from_main:
    ldx #$19
    jmp b3
  b3_from_b11:
    ldx #$19
  b3_from_b3:
  b3_from_b6:
  b3:
    lda $d012
    cmp #$fe
    bne b3_from_b3
  b4:
    lda $d012
    cmp #$ff
    bne b4
  b6:
    dex
    cpx #$0
    bne b3_from_b6
  b7:
    jsr flip
  b10:
    jsr plot
  b11:
    jmp b3_from_b11
  breturn:
    rts
}
plot: {
  b1_from_plot:
    lda #$10
    sta $4
    lda #<$4d4
    sta $2
    lda #>$4d4
    sta $2+$1
    ldx #$0
  b1_from_b3:
  b1:
  b2_from_b1:
    ldy #$0
  b2_from_b2:
  b2:
    lda $1000,x
    sta ($2),y
    inx
    iny
    cpy #$10
    bcc b2_from_b2
  b3:
    lda $2
    clc
    adc #$28
    sta $2
    bcc !+
    inc $2+$1
  !:
    dec $4
    lda $4
    bne b1_from_b3
  breturn:
    rts
}
flip: {
  b1_from_flip:
    lda #$10
    sta $4
    ldy #$f
    ldx #$0
  b1_from_b4:
  b1:
  b2_from_b1:
    lda #$10
    sta $5
  b2_from_b2:
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
    bne b2_from_b2
  b4:
    dey
    dec $4
    lda $4
    bne b1_from_b4
  b3_from_b4:
    ldx #$0
  b3_from_b3:
  b3:
    lda $1100,x
    sta $1000,x
    inx
    cpx #$0
    bne b3_from_b3
  breturn:
    rts
}
prepare: {
  b1_from_prepare:
    ldx #$0
  b1_from_b1:
  b1:
    txa
    sta $1000,x
    inx
    cpx #$0
    bne b1_from_b1
  breturn:
    rts
}
