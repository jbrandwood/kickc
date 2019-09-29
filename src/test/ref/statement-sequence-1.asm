// Tests statement sequence  generation
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldy #0
  __b1:
    tya
    tax
    axs #-[5]
    tya
    and #1
    cmp #0
    beq __b3
    cpy #5+1
    bcc __b2
  __b3:
    inx
  __b2:
    txa
    sta SCREEN,y
    iny
    cpy #$b
    bne __b1
    rts
}
