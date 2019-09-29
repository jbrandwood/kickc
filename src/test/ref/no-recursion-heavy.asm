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
  __b2:
    jsr f0
    inc.z ba
    jmp __b2
}
f0: {
    lda.z ba
    cmp #0
    bne __b1
    inc.z bb
    lda.z bb
    sta.z bb_100
    jsr fa
  __b1:
    lda #1
    cmp.z ba
    bne __b2
    inc.z bb
    lda.z bb
    sta.z bb_101
    jsr fa
  __b2:
    lda #2
    cmp.z ba
    bne __b3
    inc.z bb
    lda.z bb
    sta.z bb_102
    jsr fa
  __b3:
    lda #3
    cmp.z ba
    bne __b4
    inc.z bb
    lda.z bb
    sta.z bb_103
    jsr fa
  __b4:
    lda #4
    cmp.z ba
    bne __b5
    inc.z bb
    lda.z bb
    sta.z bb_104
    jsr fa
  __b5:
    lda #5
    cmp.z ba
    bne __b6
    inc.z bb
    lda.z bb
    sta.z bb_105
    jsr fa
  __b6:
    lda #6
    cmp.z ba
    bne __b7
    inc.z bb
    lda.z bb
    sta.z bb_106
    jsr fa
  __b7:
    lda #7
    cmp.z ba
    bne __b8
    inc.z bb
    lda.z bb
    sta.z bb_107
    jsr fa
  __b8:
    lda #8
    cmp.z ba
    bne __b9
    inc.z bb
    lda.z bb
    sta.z bb_108
    jsr fa
  __b9:
    lda #9
    cmp.z ba
    bne __breturn
    lda #0
    sta.z bb_27
    jsr fa
    lda #0
    sta.z bb
    rts
  __breturn:
    rts
}
fa: {
    lda.z bb_27
    cmp #0
    bne __b1
    inx
    stx.z bc
    jsr fb
  __b1:
    lda #1
    cmp.z bb_27
    bne __b2
    inx
    stx.z bc
    jsr fb
  __b2:
    lda #2
    cmp.z bb_27
    bne __b3
    inx
    stx.z bc
    jsr fb
  __b3:
    lda #3
    cmp.z bb_27
    bne __b4
    inx
    stx.z bc
    jsr fb
  __b4:
    lda #4
    cmp.z bb_27
    bne __b5
    inx
    stx.z bc
    jsr fb
  __b5:
    lda #5
    cmp.z bb_27
    bne __b6
    inx
    stx.z bc
    jsr fb
  __b6:
    lda #6
    cmp.z bb_27
    bne __b7
    inx
    stx.z bc
    jsr fb
  __b7:
    lda #7
    cmp.z bb_27
    bne __b8
    inx
    stx.z bc
    jsr fb
  __b8:
    lda #8
    cmp.z bb_27
    bne __b9
    inx
    stx.z bc
    jsr fb
  __b9:
    lda #9
    cmp.z bb_27
    bne __breturn
    lda #0
    sta.z bc
    jsr fb
    ldx #0
    rts
  __breturn:
    rts
}
fb: {
    lda.z bc
    cmp #0
    bne __b1
    iny
    tya
    jsr fc
  __b1:
    lda #1
    cmp.z bc
    bne __b2
    iny
    tya
    jsr fc
  __b2:
    lda #2
    cmp.z bc
    bne __b3
    iny
    tya
    jsr fc
  __b3:
    lda #3
    cmp.z bc
    bne __b4
    iny
    tya
    jsr fc
  __b4:
    lda #4
    cmp.z bc
    bne __b5
    iny
    tya
    jsr fc
  __b5:
    lda #5
    cmp.z bc
    bne __b6
    iny
    tya
    jsr fc
  __b6:
    lda #6
    cmp.z bc
    bne __b7
    iny
    tya
    jsr fc
  __b7:
    lda #7
    cmp.z bc
    bne __b8
    iny
    tya
    jsr fc
  __b8:
    lda #8
    cmp.z bc
    bne __b9
    iny
    tya
    jsr fc
  __b9:
    lda #9
    cmp.z bc
    bne __breturn
    lda #0
    jsr fc
    ldy #0
    rts
  __breturn:
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
