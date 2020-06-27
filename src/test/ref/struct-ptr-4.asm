// Minimal struct - accessing pointer to struct  in memory in a loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
  .label POINTS = $1000
main: {
    // Print points
    .label SCREEN = $400
    // Fill points
    // Fill points
    .label points = 2
    // Fill points
    // Fill points
    .label points_1 = 4
    .label i1 = 6
    ldx #0
    lda #<POINTS
    sta.z points
    lda #>POINTS
    sta.z points+1
  __b1:
    // (*points).x = i
    txa
    ldy #0
    sta (points),y
    // i+5
    txa
    clc
    adc #5
    // (*points).y = i+5
    ldy #OFFSET_STRUCT_POINT_Y
    sta (points),y
    // points++;
    lda #SIZEOF_STRUCT_POINT
    clc
    adc.z points
    sta.z points
    bcc !+
    inc.z points+1
  !:
    // for( byte i: 0..3)
    inx
    cpx #4
    bne __b1
    lda #0
    sta.z i1
    tax
    lda #<POINTS
    sta.z points_1
    lda #>POINTS
    sta.z points_1+1
  __b2:
    // SCREEN[idx++] = (*points).x
    ldy #0
    lda (points_1),y
    sta SCREEN,x
    // SCREEN[idx++] = (*points).x;
    inx
    // SCREEN[idx++] = (*points).y
    ldy #OFFSET_STRUCT_POINT_Y
    lda (points_1),y
    sta SCREEN,x
    // SCREEN[idx++] = (*points).y;
    inx
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    // points++;
    lda #SIZEOF_STRUCT_POINT
    clc
    adc.z points_1
    sta.z points_1
    bcc !+
    inc.z points_1+1
  !:
    // for( byte i: 0..3)
    inc.z i1
    lda #4
    cmp.z i1
    bne __b2
    // }
    rts
}
