// Tests treating a function like an array
// Should produce an error
// https://gitlab.com/camelot/kickc/issues/276
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr new_ball
    rts
}
new_ball: {
    inc BALLS
    rts
}
  BALLS: .fill $10, 0
