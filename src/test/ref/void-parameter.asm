// Test that void-parameter works top specify function takes no parameters
// Output is "..." in the top left corner of the screen
  // Commodore 64 PRG executable file
.file [name="void-parameter.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // print()
    ldx #0
    jsr print
    // print()
    jsr print
    // print()
    jsr print
    // }
    rts
}
print: {
    // SCREEN[idx++] = '.'
    lda #'.'
    sta SCREEN,x
    // SCREEN[idx++] = '.';
    inx
    // }
    rts
}
