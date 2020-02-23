.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label j = 3
    .label i = 2
    lda #$64
    sta.z i
  __b1:
    lda #$64
    sta.z j
  __b2:
    // nest1()
    jsr nest1
    // while (--j>0)
    dec.z j
    lda.z j
    bne __b2
    // while (--i>0)
    dec.z i
    lda.z i
    bne __b1
    // }
    rts
}
nest1: {
    .label i = 4
    lda #$64
    sta.z i
  __b1:
    lda #$64
  __b2:
    // nest2()
    jsr nest2
    // while (--j>0)
    sec
    sbc #1
    cmp #0
    bne __b2
    // while (--i>0)
    dec.z i
    lda.z i
    bne __b1
    // }
    rts
}
nest2: {
    ldx #$64
  __b1:
    ldy #$64
  __b2:
    // *SCREEN = j
    sty SCREEN
    // while (--j>0)
    dey
    cpy #0
    bne __b2
    // while (--i>0)
    dex
    cpx #0
    bne __b1
    // }
    rts
}
