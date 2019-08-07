// Tests statement sequence locality of if(cond) { stmt1; } else { stmt2; }
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
    ldy #0
  b1:
    cpy #5+1
    bcc b4
    tya
    asl
  b2:
    sta screen,x
    inx
    iny
    cpy #$b
    bne b1
    rts
  b4:
    tya
    jmp b2
}
