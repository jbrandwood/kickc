// Tests static initialization code
// No initialization code should call main() directly removing _start() and _init()
  // Commodore 64 PRG executable file
.file [name="static-init-code-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = 'o'
    lda #'o'
    sta SCREEN
    // SCREEN[1] = 'k'
    lda #'k'
    sta SCREEN+1
    // }
    rts
}
