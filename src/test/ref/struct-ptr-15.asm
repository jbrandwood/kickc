// Minimal struct -  using pointers to nested structs
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_CIRCLE = 3
  .const OFFSET_STRUCT_CIRCLE_CENTER = 1
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label _14 = 6
    .label x = 5
    .label ptr = 2
    .label i = 4
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
    sta i
    tax
    lda #<circles
    sta ptr
    lda #>circles
    sta ptr+1
  b1:
    ldy #OFFSET_STRUCT_CIRCLE_CENTER
    lda (ptr),y
    sta x
    tya
    clc
    adc ptr
    sta _14
    lda #0
    adc ptr+1
    sta _14+1
    ldy #OFFSET_STRUCT_POINT_Y
    lda (_14),y
    tay
    lda x
    sta SCREEN,x
    inx
    tya
    sta SCREEN,x
    inx
    lda #SIZEOF_STRUCT_CIRCLE
    clc
    adc ptr
    sta ptr
    bcc !+
    inc ptr+1
  !:
    inc i
    lda #2
    cmp i
    bne b1
    rts
}
  circles: .fill 3*2, 0