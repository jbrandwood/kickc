// Minimal range based for() loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN1 = $400
  .label SCREEN2 = $500
main: {
    ldx #0
  __b1:
    // SCREEN1[i] = i
    txa
    sta SCREEN1,x
    // for(byte i : 0..255)
    inx
    cpx #0
    bne __b1
    ldx #$64
  __b2:
    // SCREEN2[j] = j
    txa
    sta SCREEN2,x
    // for(j : 100..0)
    dex
    cpx #$ff
    bne __b2
    // }
    rts
}
