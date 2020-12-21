// Tests static initialization code
// No initializer code should be needed (since all values are constant)
  // Commodore 64 PRG executable file
.file [name="static-init-code-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const c1 = 'o'
  .const c2 = 'k'
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = c1
    lda #c1
    sta SCREEN
    // SCREEN[1] = c2
    lda #c2
    sta SCREEN+1
    // }
    rts
}
