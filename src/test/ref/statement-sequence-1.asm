// Tests statement sequence  generation
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldy #0
  b1:
    tya
    tax
    axs #-[5]
    tya
    and #1
    cmp #0
    beq b3
    cpy #5+1
    bcc b2
  b3:
    inx
  b2:
    txa
    sta SCREEN,y
    iny
    cpy #$b
    bne b1
    rts
}
