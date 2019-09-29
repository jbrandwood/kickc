// Minimal struct -  array with 256+ structs
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label __3 = 6
    .label __4 = $a
    .label i = 2
    .label i1 = 4
    .label __11 = 8
    .label __12 = 6
    .label __13 = $c
    .label __14 = $e
    .label __15 = $10
    .label __16 = $a
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    lda.z i
    tax
    asl
    sta.z __3
    lda.z i+1
    rol
    sta.z __3+1
    lda.z __3
    clc
    adc #<points
    sta.z __11
    lda.z __3+1
    adc #>points
    sta.z __11+1
    lda #2
    ldy #0
    sta (__11),y
    clc
    lda.z __12
    adc #<points+OFFSET_STRUCT_POINT_Y
    sta.z __12
    lda.z __12+1
    adc #>points+OFFSET_STRUCT_POINT_Y
    sta.z __12+1
    txa
    sta (__12),y
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$1f4
    bne __b1
    lda.z i
    cmp #<$1f4
    bne __b1
    lda #<0
    sta.z i1
    sta.z i1+1
  __b2:
    lda.z i1
    asl
    sta.z __4
    lda.z i1+1
    rol
    sta.z __4+1
    lda.z __4
    clc
    adc #<points
    sta.z __13
    lda.z __4+1
    adc #>points
    sta.z __13+1
    lda.z __4
    clc
    adc #<SCREEN
    sta.z __14
    lda.z __4+1
    adc #>SCREEN
    sta.z __14+1
    ldy #0
    lda (__13),y
    sta (__14),y
    lda.z __4
    clc
    adc #<points+OFFSET_STRUCT_POINT_Y
    sta.z __15
    lda.z __4+1
    adc #>points+OFFSET_STRUCT_POINT_Y
    sta.z __15+1
    clc
    lda.z __16
    adc #<SCREEN+OFFSET_STRUCT_POINT_Y
    sta.z __16
    lda.z __16+1
    adc #>SCREEN+OFFSET_STRUCT_POINT_Y
    sta.z __16+1
    lda (__15),y
    sta (__16),y
    inc.z i1
    bne !+
    inc.z i1+1
  !:
    lda.z i1+1
    cmp #>$1f4
    bne __b2
    lda.z i1
    cmp #<$1f4
    bne __b2
    rts
}
  points: .fill 2*$1f4, 0
