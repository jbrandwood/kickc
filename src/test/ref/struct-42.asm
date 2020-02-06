// Minimal struct with C-Standard behavior - copying into a struct array
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label i = 2
    lda #0
    sta.z i
  __b1:
    lda.z i
    asl
    tax
    ldy #0
  !:
    lda __0,y
    sta points,x
    inx
    iny
    cpy #SIZEOF_STRUCT_POINT
    bne !-
    inc.z i
    lda #3
    cmp.z i
    bne __b1
    lda points+2*SIZEOF_STRUCT_POINT
    sta SCREEN
    lda points+OFFSET_STRUCT_POINT_Y+2*SIZEOF_STRUCT_POINT
    sta SCREEN+1
    rts
}
  points: .fill 2*3, 0
  __0: .byte 2, 3