// Minimal struct -  variable array access
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label i = 2
    .label i1 = 3
    lda #0
    sta.z i
  __b1:
    // 2+i
    lax.z i
    axs #-[2]
    // points[i].x = 2+i
    lda.z i
    asl
    tay
    txa
    sta points,y
    // 3+i
    lda #3
    clc
    adc.z i
    // points[i].y = 3+i
    sta points+OFFSET_STRUCT_POINT_Y,y
    // for( byte i: 0..1)
    inc.z i
    lda #2
    cmp.z i
    bne __b1
    ldx #0
    txa
    sta.z i1
  __b2:
    // SCREEN[idx++] = points[i].x
    lda.z i1
    asl
    tay
    lda points,y
    sta SCREEN,x
    // SCREEN[idx++] = points[i].x;
    inx
    // SCREEN[idx++] = points[i].y
    lda points+OFFSET_STRUCT_POINT_Y,y
    sta SCREEN,x
    // SCREEN[idx++] = points[i].y;
    inx
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    // for( byte i: 0..1)
    inc.z i1
    lda #2
    cmp.z i1
    bne __b2
    // }
    rts
}
  points: .fill 2*2, 0
