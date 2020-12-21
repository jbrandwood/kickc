// Test that a nomodify parameter works
  // Commodore 64 PRG executable file
.file [name="nomodify-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // print('a')
    lda #'a'
    jsr print
    // print('b')
    lda #'b'
    jsr print
    // }
    rts
}
// print(byte register(A) c)
print: {
    // *SCREEN = c
    sta SCREEN
    // }
    rts
}
