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
    sta i
  b1:
    lax i
    axs #-[2]
    lda i
    asl
    tay
    txa
    sta points,y
    lda #3
    clc
    adc i
    sta points+OFFSET_STRUCT_POINT_Y,y
    inc i
    lda #2
    cmp i
    bne b1
    ldx #0
    txa
    sta i1
  b2:
    lda i1
    asl
    tay
    lda points,y
    sta SCREEN,x
    inx
    lda points+OFFSET_STRUCT_POINT_Y,y
    sta SCREEN,x
    inx
    lda #' '
    sta SCREEN,x
    inx
    inc i1
    lda #2
    cmp i1
    bne b2
    rts
}
  points: .fill 2*2, 0
