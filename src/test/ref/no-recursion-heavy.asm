.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label ba = 2
  .label bb = 3
  .label bb_27 = 4
  .label bc = 5
  .label bb_100 = 4
  .label bb_101 = 4
  .label bb_102 = 4
  .label bb_103 = 4
  .label bb_104 = 4
  .label bb_105 = 4
  .label bb_106 = 4
  .label bb_107 = 4
  .label bb_108 = 4
main: {
    lda #0
    sta.z ba
    tay
    tax
    sta.z bb
  b2:
    jsr f0
    inc.z ba
    jmp b2
}
f0: {
    lda.z ba
    cmp #0
    bne b1
    inc.z bb
    lda.z bb
    sta.z bb_100
    jsr fa
  b1:
    lda #1
    cmp.z ba
    bne b2
    inc.z bb
    lda.z bb
    sta.z bb_101
    jsr fa
  b2:
    lda #2
    cmp.z ba
    bne b3
    inc.z bb
    lda.z bb
    sta.z bb_102
    jsr fa
  b3:
    lda #3
    cmp.z ba
    bne b4
    inc.z bb
    lda.z bb
    sta.z bb_103
    jsr fa
  b4:
    lda #4
    cmp.z ba
    bne b5
    inc.z bb
    lda.z bb
    sta.z bb_104
    jsr fa
  b5:
    lda #5
    cmp.z ba
    bne b6
    inc.z bb
    lda.z bb
    sta.z bb_105
    jsr fa
  b6:
    lda #6
    cmp.z ba
    bne b7
    inc.z bb
    lda.z bb
    sta.z bb_106
    jsr fa
  b7:
    lda #7
    cmp.z ba
    bne b8
    inc.z bb
    lda.z bb
    sta.z bb_107
    jsr fa
  b8:
    lda #8
    cmp.z ba
    bne b9
    inc.z bb
    lda.z bb
    sta.z bb_108
    jsr fa
  b9:
    lda #9
    cmp.z ba
    bne breturn
    lda #0
    sta.z bb_27
    jsr fa
    lda #0
    sta.z bb
    rts
  breturn:
    rts
}
fa: {
    lda.z bb_27
    cmp #0
    bne b1
    inx
    stx.z bc
    jsr fb
  b1:
    lda #1
    cmp.z bb_27
    bne b2
    inx
    stx.z bc
    jsr fb
  b2:
    lda #2
    cmp.z bb_27
    bne b3
    inx
    stx.z bc
    jsr fb
  b3:
    lda #3
    cmp.z bb_27
    bne b4
    inx
    stx.z bc
    jsr fb
  b4:
    lda #4
    cmp.z bb_27
    bne b5
    inx
    stx.z bc
    jsr fb
  b5:
    lda #5
    cmp.z bb_27
    bne b6
    inx
    stx.z bc
    jsr fb
  b6:
    lda #6
    cmp.z bb_27
    bne b7
    inx
    stx.z bc
    jsr fb
  b7:
    lda #7
    cmp.z bb_27
    bne b8
    inx
    stx.z bc
    jsr fb
  b8:
    lda #8
    cmp.z bb_27
    bne b9
    inx
    stx.z bc
    jsr fb
  b9:
    lda #9
    cmp.z bb_27
    bne breturn
    lda #0
    sta.z bc
    jsr fb
    ldx #0
    rts
  breturn:
    rts
}
fb: {
    lda.z bc
    cmp #0
    bne b1
    iny
    tya
    jsr fc
  b1:
    lda #1
    cmp.z bc
    bne b2
    iny
    tya
    jsr fc
  b2:
    lda #2
    cmp.z bc
    bne b3
    iny
    tya
    jsr fc
  b3:
    lda #3
    cmp.z bc
    bne b4
    iny
    tya
    jsr fc
  b4:
    lda #4
    cmp.z bc
    bne b5
    iny
    tya
    jsr fc
  b5:
    lda #5
    cmp.z bc
    bne b6
    iny
    tya
    jsr fc
  b6:
    lda #6
    cmp.z bc
    bne b7
    iny
    tya
    jsr fc
  b7:
    lda #7
    cmp.z bc
    bne b8
    iny
    tya
    jsr fc
  b8:
    lda #8
    cmp.z bc
    bne b9
    iny
    tya
    jsr fc
  b9:
    lda #9
    cmp.z bc
    bne breturn
    lda #0
    jsr fc
    ldy #0
    rts
  breturn:
    rts
}
fc: {
    cmp #0
    cmp #1
    cmp #2
    cmp #3
    cmp #4
    cmp #5
    cmp #6
    cmp #7
    cmp #8
    cmp #9
    rts
}
