// Demonstrates initializing an array of structs
// Array of structs containing chars
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label i = 2
    ldy #0
    tya
    sta.z i
  __b1:
    // SCREEN[idx++] = points[i].x
    lda.z i
    asl
    tax
    lda points,x
    sta SCREEN,y
    // SCREEN[idx++] = points[i].x;
    iny
    // SCREEN[idx++] = points[i].y
    lda points+OFFSET_STRUCT_POINT_Y,x
    sta SCREEN,y
    // SCREEN[idx++] = points[i].y;
    iny
    // for( char i: 0..2)
    inc.z i
    lda #3
    cmp.z i
    bne __b1
    // }
    rts
}
  points: .byte 1, 2, 3, 4, 5, 6
