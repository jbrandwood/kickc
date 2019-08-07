// Tests statement sequence locality of if(cond) { stmt1; } else { stmt2; }
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
    ldy #0
  b4:
    tya
    sec
    sbc #5
    sta screen,x
    inx
  b3:
    iny
    cpy #$b
    bne b1
    rts
  b1:
    cpy #5+1
    bcs b2
    jmp b4
  b2:
    tya
    sta screen,x
    inx
    jmp b3
}
