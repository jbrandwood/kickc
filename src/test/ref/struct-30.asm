// Minimal struct with MemberUnwind behavior - array member and local initializer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const point1_x = 2
    ldy #3
  !:
    lda __0-1,y
    sta point1_initials-1,y
    dey
    bne !-
    lda #point1_x
    sta SCREEN
    lda point1_initials
    sta SCREEN+1
    lda point1_initials+1
    sta SCREEN+2
    rts
    point1_initials: .fill 3, 0
}
  __0: .text "jg"
  .byte 0
