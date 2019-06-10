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
    sta points
    lda #>POINTS
    sta points+1
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
    adc points
    sta points
    bcc !+
    inc points+1
  !:
    inx
    cpx #4
    bne b1
    lda #0
    sta i1
    tax
    lda #<POINTS
    sta points_5
    lda #>POINTS
    sta points_5+1
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
    adc points_3
    sta points_3
    bcc !+
    inc points_3+1
  !:
    inc i1
    lda #4
    cmp i1
    bne b2
    rts
}
