// Demonstrates initializing an array of structs
// Array of structs containing words
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label __4 = 3
    .label idx = 2
    lda #0
    sta.z idx
    tax
  __b1:
    // SCREEN[idx++] = points[i].x
    txa
    asl
    stx.z $ff
    clc
    adc.z $ff
    sta.z __4
    tay
    lda points,y
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = points[i].x;
    inc.z idx
    // <points[i].y
    ldy.z __4
    lda points+OFFSET_STRUCT_POINT_Y,y
    // SCREEN[idx++] = <points[i].y
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = <points[i].y;
    inc.z idx
    // >points[i].y
    ldy.z __4
    lda points+OFFSET_STRUCT_POINT_Y+1,y
    // SCREEN[idx++] = >points[i].y
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = >points[i].y;
    inc.z idx
    // for( char i: 0..2)
    inx
    cpx #3
    bne __b1
    // }
    rts
}
  points: .byte 1
  .word 2
  .byte 3
  .word 4
  .byte 5
  .word 6
