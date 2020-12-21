// Concatenates string constants in different ways
  // Commodore 64 PRG executable file
.file [name="constant-string-concat.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // SCREEN[i] = s[i]
    lda s,x
    sta SCREEN,x
    // for( byte i: 0..7)
    inx
    cpx #8
    bne __b1
    // }
    rts
  .segment Data
    s: .text "camelot"
    .byte 0
}
