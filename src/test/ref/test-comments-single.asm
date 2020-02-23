// Tests that single-line comments are compiled correctly
// Has a bunch of comments that will be moved into the generated ASM
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The C64 screen
  .label SCREEN = $400
  // One of the bytes used for addition
  .const a = 'a'
// The program entry point
main: {
    ldy #0
    ldx #0
  // Do some sums
  __b1:
    // sum(a, b)
    txa
    jsr sum
    // SCREEN[i++] = sum(a, b)
    // Output the result on the screen
    sta SCREEN,y
    // SCREEN[i++] = sum(a, b);
    iny
    // for(byte b: 0..10 )
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
// Adds up two bytes and returns the result
// a - the first byte
// b - the second byte
// Returns the sum pf the two bytes
// sum(byte register(A) b)
sum: {
    // a+b
    clc
    adc #a
    // }
    rts
}
