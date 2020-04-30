// Minimal struct with C-Standard behavior - member array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 3
  .const OFFSET_STRUCT_POINT_INITIALS = 1
  .label SCREEN = $400
main: {
    .label point1 = 2
    // point1
    ldy #SIZEOF_STRUCT_POINT
    lda #0
  !:
    dey
    sta point1,y
    bne !-
    // point1.x = 2
    lda #2
    sta.z point1
    // point1.initials[0] = 'j'
    lda #'j'
    sta point1+OFFSET_STRUCT_POINT_INITIALS
    // point1.initials[1] = 'g'
    lda #'g'
    sta point1+OFFSET_STRUCT_POINT_INITIALS+1
    // SCREEN[0] = point1.x
    lda.z point1
    sta SCREEN
    // SCREEN[1] = point1.initials[0]
    lda point1+OFFSET_STRUCT_POINT_INITIALS
    sta SCREEN+1
    // SCREEN[2] = point1.initials[1]
    lda point1+OFFSET_STRUCT_POINT_INITIALS+1
    sta SCREEN+2
    // }
    rts
}
