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
    .label points = 2
    .label points_3 = 4
    .label i1 = 6
    .label points_5 = 4
    ldx #0
    lda #<POINTS
    sta.z points
    lda #>POINTS
    sta.z points+1
  b1:
    txa
    ldy #0
    sta (points),y
    txa
    clc
    adc #5
    ldy #OFFSET_STRUCT_POINT_Y
    sta (points),y
    lda #SIZEOF_STRUCT_POINT
    clc
    adc.z points
    sta.z points
    bcc !+
    inc.z points+1
  !:
    inx
    cpx #4
    bne b1
    lda #0
    sta.z i1
    tax
    lda #<POINTS
    sta.z points_5
    lda #>POINTS
    sta.z points_5+1
  b2:
    ldy #0
    lda (points_5),y
    sta SCREEN,x
    inx
    ldy #OFFSET_STRUCT_POINT_Y
    lda (points_5),y
    sta SCREEN,x
    inx
    lda #' '
    sta SCREEN,x
    inx
    lda #SIZEOF_STRUCT_POINT
    clc
    adc.z points_3
    sta.z points_3
    bcc !+
    inc.z points_3+1
  !:
    inc.z i1
    lda #4
    cmp.z i1
    bne b2
    rts
}
