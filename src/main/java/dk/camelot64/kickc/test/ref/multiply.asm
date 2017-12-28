.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const BGCOL = $d021
  mul_sqr_lo: .fill 512, 0
  mul_sqr_hi: .fill 512, 0
  asm_mul_sqr_lo: .fill 512, 0
  asm_mul_sqr_hi: .fill 512, 0
  jsr main
main: {
    jsr init_mul_tables
    jsr init_mul_tables_asm
    jsr mul_tables_compare
    rts
}
mul_tables_compare: {
    lda #5
    sta BGCOL
    ldx #0
  b1:
    lda mul_sqr_lo,x
    cmp asm_mul_sqr_lo,x
    beq b2
    lda #2
    sta BGCOL
  b2:
    lda mul_sqr_hi+$100,x
    cmp asm_mul_sqr_hi+$100,x
    beq b3
    lda #2
    sta BGCOL
  b3:
    lda mul_sqr_lo,x
    cmp asm_mul_sqr_lo,x
    beq b4
    lda #2
    sta BGCOL
  b4:
    lda mul_sqr_hi+$100,x
    cmp asm_mul_sqr_hi+$100,x
    beq b5
    lda #2
    sta BGCOL
  b5:
    inx
    cpx #0
    bne b1
    rts
}
init_mul_tables_asm: {
    ldx #0
    txa
    .byte $c9
  lb1:
    tya
    adc #0
  ml1:
    sta asm_mul_sqr_hi,x
    tay
    cmp #$40
    txa
    ror
  ml9:
    adc #0
    sta ml9+1
    inx
  ml0:
    sta asm_mul_sqr_lo,x
    bne lb1
    inc ml0+2
    inc ml1+2
    clc
    iny
    bne lb1
    rts
}
init_mul_tables: {
    .label _15 = 2
    .label sqr = 2
    lda #0
    sta sqr
    sta sqr+1
    ldx #1
  b1:
    txa
    and #1
    cmp #0
    bne b2
    inc sqr
    bne !+
    inc sqr+1
  !:
  b2:
    lda sqr
    sta mul_sqr_lo,x
    lda sqr+1
    sta mul_sqr_hi,x
    txa
    lsr
    clc
    adc sqr
    sta sqr
    bcc !+
    inc sqr+1
  !:
    inx
    cpx #0
    bne b1
    ldx #0
  b3:
    txa
    and #1
    cmp #0
    bne b4
    inc sqr
    bne !+
    inc sqr+1
  !:
  b4:
    lda sqr
    sta mul_sqr_lo+$100,x
    lda sqr+1
    sta mul_sqr_hi+$100,x
    lda _15
    clc
    adc #<$80
    sta _15
    bcc !+
    inc _15+1
  !:
    txa
    lsr
    clc
    adc sqr
    sta sqr
    bcc !+
    inc sqr+1
  !:
    inx
    cpx #0
    bne b3
    rts
}
