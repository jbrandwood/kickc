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
  __b1:
    ldy #0
  __b2:
    // item*$10
    txa
    asl
    asl
    asl
    asl
    // item*$10|sub
    sty.z $ff
    ora.z $ff
    // cur_item[sub] = item*$10|sub
    sta (cur_item),y
    // for( byte sub: 0..ITEM_SIZE-1)
    iny
    cpy #ITEM_SIZE-1+1
    bne __b2
    // cur_item += ITEM_SIZE
    lda #ITEM_SIZE
    clc
    adc.z cur_item
    sta.z cur_item
    bcc !+
    inc.z cur_item+1
  !:
    // for( byte item: 0..ITEM_COUNT-1)
    inx
    cpx #ITEM_COUNT-1+1
    bne __b1
    // }
    rts
}
  items: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
