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
  .const SIZEOF_UNSIGNED_INT = 2
  .label _s1 = $ee
  .label _s2 = $ef
.segment Code
main: {
    // *_s1 = 7
    lda #7
    sta.z _s1
    // *_s2 = 812
    lda #<$32c
    sta.z _s2
    lda #>$32c
    sta.z _s2+1
    // *(_s2-1) = 812
    lda #<$32c
    sta.z _s2-1*SIZEOF_UNSIGNED_INT
    lda #>$32c
    sta.z _s2-1*SIZEOF_UNSIGNED_INT+1
    // }
    rts
}
