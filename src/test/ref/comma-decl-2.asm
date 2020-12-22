// Tests comma-separated declarations with different array-ness
  // Commodore 64 PRG executable file
.file [name="comma-decl-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const b = 0
    .const d = 0
    .label SCREEN = $400
    // SCREEN[0] = b
    lda #b
    sta SCREEN
    // SCREEN[1] = c[0]
    lda c
    sta SCREEN+1
    // SCREEN[2] = d
    lda #d
    sta SCREEN+2
    // }
    rts
  .segment Data
    c: .fill 3, 0
}
