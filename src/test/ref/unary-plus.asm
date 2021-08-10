// Test unary plus
  // Commodore 64 PRG executable file
.file [name="unary-plus.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_INT = 2
.segment Code
main: {
    .const i = 3
    .const j = 3
    .label SCREEN = $400
    .label SCREEN2 = $428
    // SCREEN[0] = i
    lda #i
    sta SCREEN
    // SCREEN[1] = +3
    lda #3
    sta SCREEN+1
    // SCREEN2[0] = j
    lda #<j
    sta SCREEN2
    lda #>j
    sta SCREEN2+1
    // SCREEN2[1] = +3
    lda #<3
    sta SCREEN2+1*SIZEOF_INT
    lda #>3
    sta SCREEN2+1*SIZEOF_INT+1
    // }
    rts
}
