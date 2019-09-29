// Illustrates symbolic array lengths
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SZ = $f
// Fills the array item by item with $is, where i is the item# and s is the sub#
main: {
    ldx #0
  __b1:
    txa
    sta items,x
    inx
    cpx #SZ+1
    bne __b1
    rts
}
  items: .fill SZ, 0
