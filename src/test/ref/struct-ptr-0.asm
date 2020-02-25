// Minimal struct - array of struct
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label __4 = 2
    ldx #0
  __b1:
    // points[i].x = i
    txa
    asl
    sta.z __4
    tay
    txa
    sta points,y
    // i+1
    txa
    tay
    iny
    // points[i].y = i+1
    tya
    ldy.z __4
    sta points+OFFSET_STRUCT_POINT_Y,y
    // for( byte i: 0..4)
    inx
    cpx #5
    bne __b1
    ldy #0
  __b2:
    // SCREEN[i] = points[i].x
    tya
    asl
    tax
    lda points,x
    sta SCREEN,y
    // (SCREEN+40)[i] = points[i].y
    lda points+OFFSET_STRUCT_POINT_Y,x
    sta SCREEN+$28,y
    // for( byte i: 0..4)
    iny
    cpy #5
    bne __b2
    // }
    rts
}
  points: .fill 2*4, 0
