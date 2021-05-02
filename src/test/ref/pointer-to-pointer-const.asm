// Demonstrates const pointer to pointer
  // Commodore 64 PRG executable file
.file [name="pointer-to-pointer-const.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label IRQ = $fffe
.segment Code
main: {
    // *IRQ = (void*) 0x1003
    lda #<$1003
    sta IRQ
    lda #>$1003
    sta IRQ+1
    // }
    rts
}
