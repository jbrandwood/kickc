.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label ba = 2
  .label bb = 3
  .label bb_1 = 4
  .label bc = 5
main: {
    lda #0
    sta.z ba
    tay
    tax
    sta.z bb
  __b2:
    // f0()
    jsr f0
    // ba++;
    inc.z ba
    jmp __b2
}
f0: {
    // if(ba==0)
    lda.z ba
    cmp #0
    bne __b1
    // bb++;
    inc.z bb
    lda.z bb
    sta.z bb_1
    // fa()
    jsr fa
  __b1:
    // if(ba==1)
    lda #1
    cmp.z ba
    bne __b2
    // bb++;
    inc.z bb
    lda.z bb
    sta.z bb_1
    // fa()
    jsr fa
  __b2:
    // if(ba==2)
    lda #2
    cmp.z ba
    bne __b3
    // bb++;
    inc.z bb
    lda.z bb
    sta.z bb_1
    // fa()
    jsr fa
  __b3:
    // if(ba==3)
    lda #3
    cmp.z ba
    bne __b4
    // bb++;
    inc.z bb
    lda.z bb
    sta.z bb_1
    // fa()
    jsr fa
  __b4:
    // if(ba==4)
    lda #4
    cmp.z ba
    bne __b5
    // bb++;
    inc.z bb
    lda.z bb
    sta.z bb_1
    // fa()
    jsr fa
  __b5:
    // if(ba==5)
    lda #5
    cmp.z ba
    bne __b6
    // bb++;
    inc.z bb
    lda.z bb
    sta.z bb_1
    // fa()
    jsr fa
  __b6:
    // if(ba==6)
    lda #6
    cmp.z ba
    bne __b7
    // bb++;
    inc.z bb
    lda.z bb
    sta.z bb_1
    // fa()
    jsr fa
  __b7:
    // if(ba==7)
    lda #7
    cmp.z ba
    bne __b8
    // bb++;
    inc.z bb
    lda.z bb
    sta.z bb_1
    // fa()
    jsr fa
  __b8:
    // if(ba==8)
    lda #8
    cmp.z ba
    bne __b9
    // bb++;
    inc.z bb
    lda.z bb
    sta.z bb_1
    // fa()
    jsr fa
  __b9:
    // if(ba==9)
    lda #9
    cmp.z ba
    bne __breturn
    // fa()
    lda #0
    sta.z bb_1
    jsr fa
    lda #0
    sta.z bb
    rts
  __breturn:
    // }
    rts
}
fa: {
    // if(bb==0)
    lda.z bb_1
    cmp #0
    bne __b1
    // bc++;
    inx
    stx.z bc
    // fb()
    jsr fb
  __b1:
    // if(bb==1)
    lda #1
    cmp.z bb_1
    bne __b2
    // bc++;
    inx
    stx.z bc
    // fb()
    jsr fb
  __b2:
    // if(bb==2)
    lda #2
    cmp.z bb_1
    bne __b3
    // bc++;
    inx
    stx.z bc
    // fb()
    jsr fb
  __b3:
    // if(bb==3)
    lda #3
    cmp.z bb_1
    bne __b4
    // bc++;
    inx
    stx.z bc
    // fb()
    jsr fb
  __b4:
    // if(bb==4)
    lda #4
    cmp.z bb_1
    bne __b5
    // bc++;
    inx
    stx.z bc
    // fb()
    jsr fb
  __b5:
    // if(bb==5)
    lda #5
    cmp.z bb_1
    bne __b6
    // bc++;
    inx
    stx.z bc
    // fb()
    jsr fb
  __b6:
    // if(bb==6)
    lda #6
    cmp.z bb_1
    bne __b7
    // bc++;
    inx
    stx.z bc
    // fb()
    jsr fb
  __b7:
    // if(bb==7)
    lda #7
    cmp.z bb_1
    bne __b8
    // bc++;
    inx
    stx.z bc
    // fb()
    jsr fb
  __b8:
    // if(bb==8)
    lda #8
    cmp.z bb_1
    bne __b9
    // bc++;
    inx
    stx.z bc
    // fb()
    jsr fb
  __b9:
    // if(bb==9)
    lda #9
    cmp.z bb_1
    bne __breturn
    // fb()
    lda #0
    sta.z bc
    jsr fb
    ldx #0
    rts
  __breturn:
    // }
    rts
}
fb: {
    // if(bc==0)
    lda.z bc
    cmp #0
    bne __b1
    // bd++;
    iny
    tya
    // fc()
    jsr fc
  __b1:
    // if(bc==1)
    lda #1
    cmp.z bc
    bne __b2
    // bd++;
    iny
    tya
    // fc()
    jsr fc
  __b2:
    // if(bc==2)
    lda #2
    cmp.z bc
    bne __b3
    // bd++;
    iny
    tya
    // fc()
    jsr fc
  __b3:
    // if(bc==3)
    lda #3
    cmp.z bc
    bne __b4
    // bd++;
    iny
    tya
    // fc()
    jsr fc
  __b4:
    // if(bc==4)
    lda #4
    cmp.z bc
    bne __b5
    // bd++;
    iny
    tya
    // fc()
    jsr fc
  __b5:
    // if(bc==5)
    lda #5
    cmp.z bc
    bne __b6
    // bd++;
    iny
    tya
    // fc()
    jsr fc
  __b6:
    // if(bc==6)
    lda #6
    cmp.z bc
    bne __b7
    // bd++;
    iny
    tya
    // fc()
    jsr fc
  __b7:
    // if(bc==7)
    lda #7
    cmp.z bc
    bne __b8
    // bd++;
    iny
    tya
    // fc()
    jsr fc
  __b8:
    // if(bc==8)
    lda #8
    cmp.z bc
    bne __b9
    // bd++;
    iny
    tya
    // fc()
    jsr fc
  __b9:
    // if(bc==9)
    lda #9
    cmp.z bc
    bne __breturn
    // fc()
    lda #0
    jsr fc
    ldy #0
    rts
  __breturn:
    // }
    rts
}
fc: {
    // if(bd==0)
    cmp #0
    // if(bd==1)
    cmp #1
    // if(bd==2)
    cmp #2
    // if(bd==3)
    cmp #3
    // if(bd==4)
    cmp #4
    // if(bd==5)
    cmp #5
    // if(bd==6)
    cmp #6
    // if(bd==7)
    cmp #7
    // if(bd==8)
    cmp #8
    // if(bd==9)
    cmp #9
    // }
    rts
}
