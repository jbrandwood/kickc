// Minimal struct -  using pointers to nested structs
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_CIRCLE = 3
  .const OFFSET_STRUCT_CIRCLE_CENTER = 1
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label _16 = 3
    .label ptr = 3
    .label x = 5
    .label y = 6
    .label idx = 2
    lda #2
    sta circles+OFFSET_STRUCT_CIRCLE_CENTER
    lda #3
    sta circles+OFFSET_STRUCT_CIRCLE_CENTER+OFFSET_STRUCT_POINT_Y
    lda #5
    sta circles
    lda #8
    sta circles+OFFSET_STRUCT_CIRCLE_CENTER+1*SIZEOF_STRUCT_CIRCLE
    lda #9
    sta circles+OFFSET_STRUCT_CIRCLE_CENTER+OFFSET_STRUCT_POINT_Y+1*SIZEOF_STRUCT_CIRCLE
    lda #$f
    sta circles+1*SIZEOF_STRUCT_CIRCLE
    lda #0
    sta idx
    tax
  b1:
    txa
    asl
    stx $ff
    clc
    adc $ff
    clc
    adc #<circles
    sta ptr
    lda #>circles
    adc #0
    sta ptr+1
    ldy #OFFSET_STRUCT_CIRCLE_CENTER
    lda (ptr),y
    sta x
    tya
    clc
    adc _16
    sta _16
    bcc !+
    inc _16+1
  !:
    ldy #OFFSET_STRUCT_POINT_Y
    lda (_16),y
    sta y
    lda x
    ldy idx
    sta SCREEN,y
    iny
    lda y
    sta SCREEN,y
    iny
    sty idx
    inx
    cpx #2
    bne b1
    rts
}
  circles: .fill 3*2, 0
