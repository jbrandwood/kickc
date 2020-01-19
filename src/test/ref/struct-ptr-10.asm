// Minimal struct -  array with 256+ structs
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label __3 = 6
    .label __4 = $a
    .label i = 2
    .label i1 = 4
    .label __7 = 8
    .label __8 = 6
    .label __9 = $c
    .label __10 = $a
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
    sta.z __7
    lda.z __3+1
    adc #>points
    sta.z __7+1
    lda #2
    ldy #0
    sta (__7),y
    clc
    lda.z __8
    adc #<points+OFFSET_STRUCT_POINT_Y
    sta.z __8
    lda.z __8+1
    adc #>points+OFFSET_STRUCT_POINT_Y
    sta.z __8+1
    txa
    sta (__8),y
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
    sta.z __9
    lda.z __4+1
    adc #>points
    sta.z __9+1
    clc
    lda.z __10
    adc #<SCREEN
    sta.z __10
    lda.z __10+1
    adc #>SCREEN
    sta.z __10+1
    ldy #0
  !:
    lda (__9),y
    sta (__10),y
    iny
    cpy #SIZEOF_STRUCT_POINT
    bne !-
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
