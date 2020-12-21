// Tests comma-separated declarations
  // Commodore 64 PRG executable file
.file [name="comma-decl.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const b = 'c'
    .const c = b+1
    .const d = c+1
    .label SCREEN = $400
    // SCREEN[0] = b
    lda #b
    sta SCREEN
    // SCREEN[1] = c
    lda #c
    sta SCREEN+1
    // SCREEN[2] = d
    lda #d
    sta SCREEN+2
    // }
    rts
}
