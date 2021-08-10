// Tests simple word pointer math
  // Commodore 64 PRG executable file
.file [name="word-pointer-math-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_UNSIGNED_INT = 2
.segment Code
main: {
    .label SCREEN = $400+6*$28
    .label words = $400
    .label w1 = 2
    .label w2 = 4
    // word w1 = *(words+1)
    lda words+1*SIZEOF_UNSIGNED_INT
    sta.z w1
    lda words+1*SIZEOF_UNSIGNED_INT+1
    sta.z w1+1
    // BYTE0(w1)
    lda.z w1
    // SCREEN[0] = BYTE0(w1)
    sta SCREEN
    // BYTE1(w1)
    lda.z w1+1
    // SCREEN[1] = BYTE1(w1)
    sta SCREEN+1
    // word w2 = *(words+2)
    lda words+2*SIZEOF_UNSIGNED_INT
    sta.z w2
    lda words+2*SIZEOF_UNSIGNED_INT+1
    sta.z w2+1
    // BYTE0(w2)
    lda.z w2
    // SCREEN[2] = BYTE0(w2)
    sta SCREEN+2
    // BYTE1(w2)
    lda.z w2+1
    // SCREEN[3] = BYTE1(w2)
    sta SCREEN+3
    // }
    rts
}
