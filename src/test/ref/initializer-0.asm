// Demonstrates initializing an object using = { ... } syntax
// Array of chars
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
    ldy #0
  b1:
    lda chars,y
    sta SCREEN,x
    inx
    iny
    cpy #3
    bne b1
    rts
}
  chars: .byte 1, 2, 3
