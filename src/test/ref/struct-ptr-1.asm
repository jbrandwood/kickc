// Minimal struct - array of struct - near pointer math indexing
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFS_Y = 1
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // i*SIZEOF_POINT
    txa
    asl
    tay
    // *((byte*)points+OFFS_X+i*SIZEOF_POINT) = i
    txa
    sta points,y
    // i+4
    txa
    clc
    adc #4
    // *((byte*)points+OFFS_Y+i*SIZEOF_POINT) = i+4
    // points[i].x = i;
    sta points+OFFS_Y,y
    // for( byte i: 0..3)
    inx
    cpx #4
    bne __b1
    ldy #0
  __b2:
    // i*SIZEOF_POINT
    tya
    asl
    tax
    // SCREEN[i] = *((byte*)points+OFFS_X+i*SIZEOF_POINT)
    lda points,x
    sta SCREEN,y
    // (SCREEN+40)[i] = *((byte*)points+OFFS_Y+i*SIZEOF_POINT)
    // SCREEN[i] = points[i].x;
    lda points+OFFS_Y,x
    sta SCREEN+$28,y
    // for( byte i: 0..3)
    iny
    cpy #4
    bne __b2
    // }
    rts
}
  points: .fill 2*4, 0
