// These pointers lives on zeropage
// KickAss should be able to add .z to the STAs
  // Commodore 64 PRG executable file
.file [name="pcea-pointer-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label _s1 = $ee
  .label _s2 = $ef
.segment Code
main: {
    // *_s1 = 7
    lda #7
    sta _s1
    // *_s2 = 7
    sta _s2
    lda #>7
    sta _s2+1
    // }
    rts
}
