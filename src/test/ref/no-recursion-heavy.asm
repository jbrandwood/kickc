.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label ba = 2
  .label be = 6
  .label bb = 3
  .label bb_27 = 4
  .label bc = 5
  .label bb_101 = 4
  .label bb_102 = 4
  .label bb_103 = 4
  .label bb_104 = 4
  .label bb_105 = 4
  .label bb_106 = 4
  .label bb_107 = 4
  .label bb_108 = 4
  .label bb_109 = 4
main: {
    lda #0
    sta ba
    sta be
    tay
    tax
    sta bb
  b2:
    jsr f0
    inc ba
    jmp b2
}
f0: {
    lda ba
    cmp #0
    bne b1
    inc bb
    lda bb
    sta bb_101
    jsr fa
  b1:
    lda ba
    cmp #1
    bne b2
    inc bb
    lda bb
    sta bb_102
    jsr fa
  b2:
    lda ba
    cmp #2
    bne b3
    inc bb
    lda bb
    sta bb_103
    jsr fa
  b3:
    lda ba
    cmp #3
    bne b4
    inc bb
    lda bb
    sta bb_104
    jsr fa
  b4:
    lda ba
    cmp #4
    bne b5
    inc bb
    lda bb
    sta bb_105
    jsr fa
  b5:
    lda ba
    cmp #5
    bne b6
    inc bb
    lda bb
    sta bb_106
    jsr fa
  b6:
    lda ba
    cmp #6
    bne b7
    inc bb
    lda bb
    sta bb_107
    jsr fa
  b7:
    lda ba
    cmp #7
    bne b8
    inc bb
    lda bb
    sta bb_108
    jsr fa
  b8:
    lda ba
    cmp #8
    bne b9
    inc bb
    lda bb
    sta bb_109
    jsr fa
  b9:
    lda ba
    cmp #9
    bne breturn
    lda #0
    sta bb_27
    jsr fa
    lda #0
    sta bb
  breturn:
    rts
}
fa: {
    lda bb_27
    cmp #0
    bne b1
    inx
    stx bc
    jsr fb
  b1:
    lda bb_27
    cmp #1
    bne b2
    inx
    stx bc
    jsr fb
  b2:
    lda bb_27
    cmp #2
    bne b3
    inx
    stx bc
    jsr fb
  b3:
    lda bb_27
    cmp #3
    bne b4
    inx
    stx bc
    jsr fb
  b4:
    lda bb_27
    cmp #4
    bne b5
    inx
    stx bc
    jsr fb
  b5:
    lda bb_27
    cmp #5
    bne b6
    inx
    stx bc
    jsr fb
  b6:
    lda bb_27
    cmp #6
    bne b7
    inx
    stx bc
    jsr fb
  b7:
    lda bb_27
    cmp #7
    bne b8
    inx
    stx bc
    jsr fb
  b8:
    lda bb_27
    cmp #8
    bne b9
    inx
    stx bc
    jsr fb
  b9:
    lda bb_27
    cmp #9
    bne breturn
    lda #0
    sta bc
    jsr fb
    ldx #0
  breturn:
    rts
}
fb: {
    lda bc
    cmp #0
    bne b1
    iny
    tya
    jsr fc
  b1:
    lda bc
    cmp #1
    bne b2
    iny
    tya
    jsr fc
  b2:
    lda bc
    cmp #2
    bne b3
    iny
    tya
    jsr fc
  b3:
    lda bc
    cmp #3
    bne b4
    iny
    tya
    jsr fc
  b4:
    lda bc
    cmp #4
    bne b5
    iny
    tya
    jsr fc
  b5:
    lda bc
    cmp #5
    bne b6
    iny
    tya
    jsr fc
  b6:
    lda bc
    cmp #6
    bne b7
    iny
    tya
    jsr fc
  b7:
    lda bc
    cmp #7
    bne b8
    iny
    tya
    jsr fc
  b8:
    lda bc
    cmp #8
    bne b9
    iny
    tya
    jsr fc
  b9:
    lda bc
    cmp #9
    bne breturn
    lda #0
    jsr fc
    ldy #0
  breturn:
    rts
}
fc: {
    cmp #0
    bne b1
    inc be
  b1:
    cmp #1
    bne b2
    inc be
  b2:
    cmp #2
    bne b3
    inc be
  b3:
    cmp #3
    bne b4
    inc be
  b4:
    cmp #4
    bne b5
    inc be
  b5:
    cmp #5
    bne b6
    inc be
  b6:
    cmp #6
    bne b7
    inc be
  b7:
    cmp #7
    bne b8
    inc be
  b8:
    cmp #8
    bne b9
    inc be
  b9:
    cmp #9
    bne breturn
    lda #0
    sta be
  breturn:
    rts
}
