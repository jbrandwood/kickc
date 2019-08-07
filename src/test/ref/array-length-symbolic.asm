// Illustrates symbolic array lengths
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const ITEM_COUNT = 3
  .const ITEM_SIZE = 5
// Fills the array item by item with $is, where i is the item# and s is the sub#
main: {
    .label cur_item = 2
    lda #<items
    sta.z cur_item
    lda #>items
    sta.z cur_item+1
    ldx #0
  b1:
    ldy #0
  b2:
    txa
    asl
    asl
    asl
    asl
    sty.z $ff
    ora.z $ff
    sta (cur_item),y
    iny
    cpy #ITEM_SIZE-1+1
    bne b2
    lda #ITEM_SIZE
    clc
    adc.z cur_item
    sta.z cur_item
    bcc !+
    inc.z cur_item+1
  !:
    inx
    cpx #ITEM_COUNT-1+1
    bne b1
    rts
}
  items: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
