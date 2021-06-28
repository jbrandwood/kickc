// Test parsing a negated struct reference - which causes problems with the ASMREL labels !a++
// https://gitlab.com/camelot/kickc/issues/266
  // Commodore 64 PRG executable file
.file [name="parse-negated-struct-ref.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label a = aa
    // if(!a->b)
    lda a
    bne !a+
    // *SCREEN = 'a'
    lda #'a'
    sta SCREEN
    // asm
    // ASMREL labels
    jmp !a+
  !a:
    // }
    rts
}
.segment Data
  aa: .byte 1
