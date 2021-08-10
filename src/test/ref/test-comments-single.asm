// Tests that single-line comments are compiled correctly
// Has a bunch of comments that will be moved into the generated ASM
  // Commodore 64 PRG executable file
.file [name="test-comments-single.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // One of the bytes used for addition
  .const a = 'a'
  // The C64 screen
  .label SCREEN = $400
.segment Code
// The program entry point
main: {
    ldx #0
    ldy #0
  // Do some sums
  __b1:
    // sum(a, b)
    tya
    jsr sum
    // SCREEN[i++] = sum(a, b)
    // Output the result on the screen
    sta SCREEN,x
    // SCREEN[i++] = sum(a, b);
    inx
    // for(byte b: 0..10 )
    iny
    cpy #$b
    bne __b1
    // }
    rts
}
// Adds up two bytes and returns the result
// a - the first byte
// b - the second byte
// Returns the sum pf the two bytes
// __register(A) char sum(char a, __register(A) char b)
sum: {
    // byte r = a+b
    // calculate the sum
    clc
    adc #@a
    // }
    rts
}
