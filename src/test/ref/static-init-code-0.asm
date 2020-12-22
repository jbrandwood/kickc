// Tests static initialization code
// Currently placed outside any function scope and pushed into @begin block.
// To be put into an initializer function.
  // Commodore 64 PRG executable file
.file [name="static-init-code-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  // Initialize a volatile ZP-variable (will be done in the initializer)
  .label c1 = 2
  // Initialize another volatile ZP-variable (will be done in the initializer)
  .label c2 = 3
.segment Code
__start: {
    // c1 = 'o'
    lda #'o'
    sta.z c1
    // c2 = 'k'
    lda #'k'
    sta.z c2
    jsr main
    rts
}
main: {
    // SCREEN[0] = c1
    lda.z c1
    sta SCREEN
    // SCREEN[1] = c2
    lda.z c2
    sta SCREEN+1
    // }
    rts
}
