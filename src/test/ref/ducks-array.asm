/// @file
/// Functions for performing input and output.
  // Commodore 64 PRG executable file
.file [name="ducks-array.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // chrout(149)
    lda #$95
    sta.z chrout.petscii
    jsr chrout
    // chrout(points[0])
    lda points
    sta.z chrout.petscii
    jsr chrout
    // chrout(points[1])
    lda points+1
    sta.z chrout.petscii
    jsr chrout
    // chrout(points[2])
    lda points+2
    sta.z chrout.petscii
    jsr chrout
    // chrout(points[3])
    lda points+3
    sta.z chrout.petscii
    jsr chrout
    // }
    rts
}
// void chrout(__zp(2) volatile char petscii)
chrout: {
    .label petscii = 2
    // asm
    jsr $ffd2
    // }
    rts
}
.segment Data
  points: .byte 1, 2, 3, 4
