// Minimal struct with C-Standard behavior - member is array, copy assignment (not supported yet)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_INITIALS = 1
main: {
    .label point1 = 2
    lda #2
    sta.z point1
    tay
  !:
    lda __0-1,y
    sta point1+OFFSET_STRUCT_POINT_INITIALS-1,y
    dey
    bne !-
    lda.z point1
    sta SCREEN
    lda point1+OFFSET_STRUCT_POINT_INITIALS
    sta SCREEN+1
    lda point1+OFFSET_STRUCT_POINT_INITIALS+1
    sta SCREEN+2
    rts
}
  __0: .byte 'j', 'g'
