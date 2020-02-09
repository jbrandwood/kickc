// Demonstrates problem with returning a struct into a dereferenced pointer to a struct
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label __1_x = 2
    lda #0
    jsr get
    sta SCREEN
    lda #get.p_y
    sta SCREEN+OFFSET_STRUCT_POINT_Y
    ldy #1
  __b1:
    tya
    jsr get
    sta.z __1_x
    tya
    asl
    tax
    lda.z __1_x
    sta SCREEN,x
    lda #get.p_y
    sta SCREEN+OFFSET_STRUCT_POINT_Y,x
    iny
    cpy #3
    bne __b1
    rts
}
// get(byte register(A) i)
get: {
    .label p_y = 7
    rts
}
