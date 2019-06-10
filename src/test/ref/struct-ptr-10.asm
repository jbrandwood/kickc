// Minimal struct -  array with 256+ structs
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label _3 = 6
    .label _4 = $a
    .label i = 2
    .label i1 = 4
    .label _11 = 8
    .label _12 = 6
    .label _13 = $c
    .label _14 = $e
    .label _15 = $10
    .label _16 = $a
    lda #<0
    sta i
    sta i+1
  b1:
    lda i
    tax
    asl
    sta _3
    lda i+1
    rol
    sta _3+1
    lda _3
    clc
    adc #<points
    sta _11
    lda _3+1
    adc #>points
    sta _11+1
    lda #2
    ldy #0
    sta (_11),y
    clc
    lda _12
    adc #<points+OFFSET_STRUCT_POINT_Y
    sta _12
    lda _12+1
    adc #>points+OFFSET_STRUCT_POINT_Y
    sta _12+1
    txa
    sta (_12),y
    inc i
    bne !+
    inc i+1
  !:
    lda i+1
    cmp #>$1f4
    bne b1
    lda i
    cmp #<$1f4
    bne b1
    lda #<0
    sta i1
    sta i1+1
  b2:
    lda i1
    asl
    sta _4
    lda i1+1
    rol
    sta _4+1
    lda _4
    clc
    adc #<points
    sta _13
    lda _4+1
    adc #>points
    sta _13+1
    lda _4
    clc
    adc #<SCREEN
    sta _14
    lda _4+1
    adc #>SCREEN
    sta _14+1
    ldy #0
    lda (_13),y
    sta (_14),y
    lda _4
    clc
    adc #<points+OFFSET_STRUCT_POINT_Y
    sta _15
    lda _4+1
    adc #>points+OFFSET_STRUCT_POINT_Y
    sta _15+1
    clc
    lda _16
    adc #<SCREEN+OFFSET_STRUCT_POINT_Y
    sta _16
    lda _16+1
    adc #>SCREEN+OFFSET_STRUCT_POINT_Y
    sta _16+1
    lda (_15),y
    sta (_16),y
    inc i1
    bne !+
    inc i1+1
  !:
    lda i1+1
    cmp #>$1f4
    bne b2
    lda i1
    cmp #<$1f4
    bne b2
    rts
}
  points: .fill 2*$1f4, 0
