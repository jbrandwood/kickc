// Examples of unsigned comparisons to values outside the range of unsigned
// These should be optimized to constants
  // Commodore 64 PRG executable file
.file [name="optimize-unsigned-comparisons.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    ldx #0
  __b2:
    // for( char i: 0..7)
    inx
    cpx #8
    bne __b2
    // }
    rts
}
