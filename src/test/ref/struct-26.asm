// Minimal struct with C-Standard behavior - member is array, copy assignment
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_POINT = 3
  .const OFFSET_STRUCT_POINT_INITIALS = 1
main: {
    .label point1 = 2
    .label point2 = 5
    ldy #SIZEOF_STRUCT_POINT
    lda #0
  !:
    dey
    sta point1,y
    bne !-
    lda #2
    sta.z point1
    lda #'j'
    sta point1+OFFSET_STRUCT_POINT_INITIALS
    lda #'g'
    sta point1+OFFSET_STRUCT_POINT_INITIALS+1
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda point1-1,y
    sta point2-1,y
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
