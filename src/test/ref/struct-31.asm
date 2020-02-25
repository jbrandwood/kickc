// Minimal struct with MemberUnwind behavior - simple members and local initializer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const point1_x = 2
    .const point1_y = 3
    // SCREEN[0] = point1.x
    lda #point1_x
    sta SCREEN
    // SCREEN[1] = point1.y
    lda #point1_y
    sta SCREEN+1
    // }
    rts
}
