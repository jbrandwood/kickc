.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const ITEM_COUNT = 2
  .const ITEM_SIZE = 5
  jsr main
main: {
    .label cur_item = 2
    lda #<items
    sta cur_item
    lda #>items
    sta cur_item+1
    ldx #0
  b1:
    ldy #0
  b2:
    txa
    asl
    asl
    asl
    asl
    sty $ff
    ora $ff
    sta (cur_item),y
    iny
    cpy #ITEM_SIZE-1+1
    bne b2
    lda cur_item
    clc
    adc #ITEM_SIZE
    sta cur_item
    bcc !+
    inc cur_item+1
  !:
    inx
    cpx #ITEM_COUNT-1+1
    bne b1
    rts
}
  items: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
