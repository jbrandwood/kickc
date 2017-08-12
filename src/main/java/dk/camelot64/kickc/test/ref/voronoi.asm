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
    beq b1
  b2:
    lda $1100
    clc
    adc #$1
    sta $1100
    lda $1100
    cmp #$19
    beq b3
  b4:
    ldx $1001
    dex
    stx $1001
    lda $1001
    cmp #$ff
    beq b5
  b6:
    lda $1102
    clc
    adc #$1
    sta $1102
    lda $1102
    cmp #$19
    beq b7
  b8:
    ldx $1103
    dex
    stx $1103
    lda $1103
    cmp #$ff
    beq b9
  breturn:
    rts
  b9:
    lda #$19
    sta $1103
    lda $1003
    clc
    adc #$7
    sta $1003
    lda $1003
    cmp #$28
    bcs b11
    jmp breturn
  b11:
    lda $1003
    sec
    sbc #$28
    sta $1003
    jmp breturn
  b7:
    lda #$0
    sta $1102
    jmp b8
  b5:
    lda #$28
    sta $1001
    jmp b6
  b3:
    lda #$0
    sta $1100
    jmp b4
  b1:
    lda #$0
    sta $1000
    jmp b2
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
    bcc b2
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
    bcc b1
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
    beq b2
  b3:
    lda $9
    cmp $7
    bcc b6
    lda $9
    sec
    sbc $7
    sta $7
  b8:
    lda $a
    cmp $b
    bcc b9
    lda $a
    sec
    sbc $b
    clc
    adc $7
  b11:
    cmp $6
    bcc b12
  b13:
    inx
    cpx $8
    bcc b1
    jmp breturn
  breturn_from_b2:
    ldy #$0
  breturn:
    rts
  b12:
    ldy $1200,x
    sta $6
    jmp b13
  b9:
    lda $b
    sec
    sbc $a
    clc
    adc $7
    jmp b11
  b6:
    lda $7
    sec
    sbc $9
    sta $7
    jmp b8
  b2:
    lda $a
    cmp $b
    beq breturn_from_b2
    jmp b3
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
