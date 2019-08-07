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
    sta.z i
    sta.z i+1
  b1:
    lda.z i
    tax
    asl
    sta.z _3
    lda.z i+1
    rol
    sta.z _3+1
    lda.z _3
    clc
    adc #<points
    sta.z _11
    lda.z _3+1
    adc #>points
    sta.z _11+1
    lda #2
    ldy #0
    sta (_11),y
    clc
    lda.z _12
    adc #<points+OFFSET_STRUCT_POINT_Y
    sta.z _12
    lda.z _12+1
    adc #>points+OFFSET_STRUCT_POINT_Y
    sta.z _12+1
    txa
    sta (_12),y
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$1f4
    bne b1
    lda.z i
    cmp #<$1f4
    bne b1
    lda #<0
    sta.z i1
    sta.z i1+1
  b2:
    lda.z i1
    asl
    sta.z _4
    lda.z i1+1
    rol
    sta.z _4+1
    lda.z _4
    clc
    adc #<points
    sta.z _13
    lda.z _4+1
    adc #>points
    sta.z _13+1
    lda.z _4
    clc
    adc #<SCREEN
    sta.z _14
    lda.z _4+1
    adc #>SCREEN
    sta.z _14+1
    ldy #0
    lda (_13),y
    sta (_14),y
    lda.z _4
    clc
    adc #<points+OFFSET_STRUCT_POINT_Y
    sta.z _15
    lda.z _4+1
    adc #>points+OFFSET_STRUCT_POINT_Y
    sta.z _15+1
    clc
    lda.z _16
    adc #<SCREEN+OFFSET_STRUCT_POINT_Y
    sta.z _16
    lda.z _16+1
    adc #>SCREEN+OFFSET_STRUCT_POINT_Y
    sta.z _16+1
    lda (_15),y
    sta (_16),y
    inc.z i1
    bne !+
    inc.z i1+1
  !:
    lda.z i1+1
    cmp #>$1f4
    bne b2
    lda.z i1
    cmp #<$1f4
    bne b2
    rts
}
  points: .fill 2*$1f4, 0
