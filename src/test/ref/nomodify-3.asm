// Test that a volatile nomodify-variable works as expected
  // Commodore 64 PRG executable file
.file [name="nomodify-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label i = 2
.segment Code
__start: {
    // i = 7
    lda #7
    sta.z i
    jsr main
    rts
}
main: {
    // SCREEN[0] = i
    lda.z i
    sta SCREEN
    // }
    rts
}
