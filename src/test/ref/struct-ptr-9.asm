// Minimal struct -  array access with struct value copying (and initializing)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label i1 = 2
    ldy #0
  __b1:
    tya
    asl
    tax
    lda #2
    sta points,x
    tya
    sta points+OFFSET_STRUCT_POINT_Y,x
    iny
    cpy #2
    bne __b1
    lda #0
    sta.z i1
  __b2:
    lda.z i1
    asl
    ldx #SIZEOF_STRUCT_POINT
    tay
  !:
    lda points,y
    sta SCREEN,y
    iny
    dex
    bne !-
    inc.z i1
    lda #2
    cmp.z i1
    bne __b2
    rts
}
  points: .fill 2*2, 0
