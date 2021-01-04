// Illustrates symbolic array lengths
  // Commodore 64 PRG executable file
.file [name="array-length-symbolic-min.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SZ = $f
.segment Code
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
.segment Data
  items: .fill SZ, 0
