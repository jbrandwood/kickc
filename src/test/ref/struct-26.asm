// Minimal struct with C-Standard behavior - member is array, copy assignment (not supported yet)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_INITIALS = 1
main: {
    .label point1 = 2
    .label point2 = 5
    lda #0
    sta.z point1
    ldx #2
  !:
    dex
    sta point1+OFFSET_STRUCT_POINT_INITIALS,x
    bne !-
    lda #2
    sta.z point1
    lda #'j'
    sta point1+OFFSET_STRUCT_POINT_INITIALS
    lda #'g'
    sta point1+OFFSET_STRUCT_POINT_INITIALS+1
    lda.z point1
    sta.z point2
    ldy #2
  !:
    lda point1+OFFSET_STRUCT_POINT_INITIALS-1,y
    sta point2+OFFSET_STRUCT_POINT_INITIALS-1,y
    dey
    bne !-
    lda.z point2
    sta SCREEN
    lda point2+OFFSET_STRUCT_POINT_INITIALS
    sta SCREEN+1
    lda point2+OFFSET_STRUCT_POINT_INITIALS+1
    sta SCREEN+2
    rts
}
