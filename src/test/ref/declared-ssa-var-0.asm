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
  // idx_nssa_g
  lda #0
  sta.z idx_nssa_g
  jsr main
  rts
main: {
    .label idx_nssa_l = 3
    // idx_nssa_l
    lda #0
    sta.z idx_nssa_l
    // SCREEN1[idx_ssa_g++] = 'C'
    lda #'C'
    sta SCREEN1
    ldy #1
    ldx #'M'
  __b1:
    // SCREEN1[idx_ssa_g++] = i
    txa
    sta SCREEN1,y
    // SCREEN1[idx_ssa_g++] = i;
    iny
    // for( char i: 'M'..'L')
    dex
    cpx #'L'-1
    bne __b1
    // SCREEN1[idx_ssa_g++] = '!'
    lda #'!'
    sta SCREEN1,y
    // SCREEN2[idx_nssa_g++] = 'C'
    lda #'C'
    ldy.z idx_nssa_g
    sta SCREEN2,y
    // SCREEN2[idx_nssa_g++] = 'C';
    inc.z idx_nssa_g
    lda #'M'
  __b3:
    // SCREEN2[idx_nssa_g++] = i
    ldy.z idx_nssa_g
    sta SCREEN2,y
    // SCREEN2[idx_nssa_g++] = i;
    inc.z idx_nssa_g
    // for( char i: 'M'..'L')
    sec
    sbc #1
    cmp #'L'-1
    bne __b3
    // SCREEN2[idx_nssa_g++] = '!'
    lda #'!'
    ldy.z idx_nssa_g
    sta SCREEN2,y
    // SCREEN2[idx_nssa_g++] = '!';
    inc.z idx_nssa_g
    // SCREEN3[idx_ssa_l++] = 'C'
    lda #'C'
    sta SCREEN3
    ldy #1
    ldx #'M'
  __b5:
    // SCREEN3[idx_ssa_l++] = i
    txa
    sta SCREEN3,y
    // SCREEN3[idx_ssa_l++] = i;
    iny
    // for( char i: 'M'..'L')
    dex
    cpx #'L'-1
    bne __b5
    // SCREEN3[idx_ssa_l++] = '!'
    lda #'!'
    sta SCREEN3,y
    // SCREEN4[idx_nssa_l++] = 'C'
    lda #'C'
    ldy.z idx_nssa_l
    sta SCREEN4,y
    // SCREEN4[idx_nssa_l++] = 'C';
    inc.z idx_nssa_l
    lda #'M'
  __b7:
    // SCREEN4[idx_nssa_l++] = i
    ldy.z idx_nssa_l
    sta SCREEN4,y
    // SCREEN4[idx_nssa_l++] = i;
    inc.z idx_nssa_l
    // for( char i: 'M'..'L')
    sec
    sbc #1
    cmp #'L'-1
    bne __b7
    // SCREEN4[idx_nssa_l++] = '!'
    lda #'!'
    ldy.z idx_nssa_l
    sta SCREEN4,y
    // SCREEN4[idx_nssa_l++] = '!';
    inc.z idx_nssa_l
    // }
    rts
}
