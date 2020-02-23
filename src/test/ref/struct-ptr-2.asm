// Minimal struct - array of struct - far pointer math indexing
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFS_Y = 1
main: {
    .label SCREEN = $400
    .label point_i = 2
    .label point_i1 = 4
    ldx #0
  __b1:
    // points+i
    txa
    asl
    tay
    // point_i = points+i
    tya
    clc
    adc #<points
    sta.z point_i
    lda #>points
    adc #0
    sta.z point_i+1
    // *((byte*)point_i+OFFS_X) = i
    txa
    sta points,y
    // i+4
    txa
    clc
    adc #4
    // *((byte*)point_i+OFFS_Y)  = i+4
    // points[i].x = i;
    ldy #OFFS_Y
    sta (point_i),y
    // for( byte i: 0..3)
    inx
    cpx #4
    bne __b1
    ldx #0
  __b2:
    // points+i
    txa
    asl
    tay
    // point_i = points+i
    tya
    clc
    adc #<points
    sta.z point_i1
    lda #>points
    adc #0
    sta.z point_i1+1
    // SCREEN[i] = *((byte*)point_i+OFFS_X)
    lda points,y
    sta SCREEN,x
    // (SCREEN+40)[i] = *((byte*)point_i+OFFS_Y)
    // SCREEN[i] = points[i].x;
    ldy #OFFS_Y
    lda (point_i1),y
    sta SCREEN+$28,x
    // for( byte i: 0..3)
    inx
    cpx #4
    bne __b2
    // }
    rts
}
  points: .fill 2*4, 0
