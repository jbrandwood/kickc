// Minimal struct with MemberUnwind behavior - array member and local initializer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const point1_x = 2
    // point1 = { 2, "jg" }
    ldy #3
  !:
    lda __0-1,y
    sta point1_initials-1,y
    dey
    bne !-
    // SCREEN[0] = point1.x
    lda #point1_x
    sta SCREEN
    // SCREEN[1] = point1.initials[0]
    lda point1_initials
    sta SCREEN+1
    // SCREEN[2] = point1.initials[1]
    lda point1_initials+1
    sta SCREEN+2
    // }
    rts
    point1_initials: .fill 3, 0
}
  __0: .text "jg"
  .byte 0
