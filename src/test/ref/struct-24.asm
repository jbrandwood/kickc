// Minimal struct with C-Standard behavior - member array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_POINT = 3
  .const OFFSET_STRUCT_POINT_INITIALS = 1
main: {
    .label point1 = 2
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
    lda.z point1
    sta SCREEN
    lda point1+OFFSET_STRUCT_POINT_INITIALS
    sta SCREEN+1
    lda point1+OFFSET_STRUCT_POINT_INITIALS+1
    sta SCREEN+2
    rts
}
