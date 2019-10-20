// Tests declaring variables as __ssa / __notssa
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN1 = $400
  .label SCREEN2 = $400+$28
  .label SCREEN3 = $400+$50
  .label SCREEN4 = $400+$78
  .label idx_nssa_g = 2
__bbegin:
  lda #0
  sta.z idx_nssa_g
  jsr main
  rts
main: {
    .label idx_nssa_l = 3
    lda #0
    sta.z idx_nssa_l
    lda #'C'
    sta SCREEN1
    ldy #1
    ldx #'M'
  __b1:
    txa
    sta SCREEN1,y
    iny
    dex
    cpx #'L'-1
    bne __b1
    lda #'!'
    sta SCREEN1,y
    lda #'C'
    ldy.z idx_nssa_g
    sta SCREEN2,y
    inc.z idx_nssa_g
    lda #'M'
  __b3:
    ldy.z idx_nssa_g
    sta SCREEN2,y
    inc.z idx_nssa_g
    sec
    sbc #1
    cmp #'L'-1
    bne __b3
    lda #'!'
    ldy.z idx_nssa_g
    sta SCREEN2,y
    inc.z idx_nssa_g
    lda #'C'
    sta SCREEN3
    ldy #1
    ldx #'M'
  __b5:
    txa
    sta SCREEN3,y
    iny
    dex
    cpx #'L'-1
    bne __b5
    lda #'!'
    sta SCREEN3,y
    lda #'C'
    ldy.z idx_nssa_l
    sta SCREEN4,y
    inc.z idx_nssa_l
    lda #'M'
  __b7:
    ldy.z idx_nssa_l
    sta SCREEN4,y
    inc.z idx_nssa_l
    sec
    sbc #1
    cmp #'L'-1
    bne __b7
    lda #'!'
    ldy.z idx_nssa_l
    sta SCREEN4,y
    inc.z idx_nssa_l
    rts
}
