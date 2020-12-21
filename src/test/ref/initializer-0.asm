// Demonstrates initializing an object using = { ... } syntax
// Array of chars
  // Commodore 64 PRG executable file
.file [name="initializer-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    ldx #0
    ldy #0
  __b1:
    // SCREEN[idx++] = chars[i]
    lda chars,y
    sta SCREEN,x
    // SCREEN[idx++] = chars[i];
    inx
    // for( char i: 0..2)
    iny
    cpy #3
    bne __b1
    // }
    rts
}
.segment Data
  chars: .byte 1, 2, 3
