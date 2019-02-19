/* Tests that block comments are compiled correctly
 * Has a bunch of comments that will be moved into the generated ASM
 */
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The C64 screen
  .label SCREEN = $400
  // One of the bytes used for addition
  .const a = 'a'
/* The program entry point */
main: {
    ldx #0
    ldy #0
  // Do some sums
  b1:
    jsr sum
    // Output the result on the screen
    sta SCREEN,x
    inx
    iny
    cpy #$b
    bne b1
    rts
}
/** Adds up two bytes and returns the result
 * a - the first byte
 * b - the second byte
 * Returns the sum pf the two bytes
 */
// sum(byte register(Y) b)
sum: {
    tya
    clc
    adc #a
    rts
}
