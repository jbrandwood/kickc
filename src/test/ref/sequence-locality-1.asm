// Tests statement sequence locality of if(cond) { stmt1; } else { stmt2; }
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
    ldy #0
  __b1:
    cpy #5+1
    bcc __b4
    tya
    asl
  __b2:
    sta screen,x
    inx
    iny
    cpy #$b
    bne __b1
    rts
  __b4:
    tya
    jmp __b2
}
