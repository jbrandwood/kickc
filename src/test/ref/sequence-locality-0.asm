// Tests statement sequence locality of if(cond) { stmt1; } else { stmt2; }
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldy #0
    ldx #0
  b1:
    cpx #5+1
    bcs b2
    txa
    sec
    sbc #5
    sta screen,y
    iny
  b3:
    inx
    cpx #$b
    bne b1
    rts
  b2:
    txa
    sta screen,y
    iny
    jmp b3
}
