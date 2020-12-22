// Tests that inline asm uses clause makes the compiler not cull a procedure referenced
  // Commodore 64 PRG executable file
.file [name="asm-uses-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label BG_COLOR = $d020
.segment Code
// Function only used inside the inline asm
init: {
    // *BG_COLOR = 0
    lda #0
    sta BG_COLOR
    // }
    rts
}
main: {
    // asm
    jsr init
    // }
    rts
}
