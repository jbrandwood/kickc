// Illustrates symbolic array lengths
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SZ = $f
// Fills the array item by item with $is, where i is the item# and s is the sub#
main: {
    ldx #0
  __b1:
    // cur_item[sub] = sub
    txa
    sta items,x
    // for( byte sub: 0..SZ)
    inx
    cpx #SZ+1
    bne __b1
    // }
    rts
}
  items: .fill SZ, 0
