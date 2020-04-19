// Minimal struct -  array with 256+ structs
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
main: {
    .label SCREEN = $400
    .label __2 = 6
    .label __3 = $a
    .label i = 2
    .label i1 = 4
    .label __4 = 8
    .label __5 = 6
    .label __6 = $c
    .label __7 = $a
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // points[i] = { 2, (byte)i }
    lda.z i
    asl
    sta.z __2
    lda.z i+1
    rol
    sta.z __2+1
    lda.z __2
    clc
    adc #<points
    sta.z __4
    lda.z __2+1
    adc #>points
    sta.z __4+1
    lda #2
    ldy #0
    sta (__4),y
    clc
    lda.z __5
    adc #<points+OFFSET_STRUCT_POINT_Y
    sta.z __5
    lda.z __5+1
    adc #>points+OFFSET_STRUCT_POINT_Y
    sta.z __5+1
    lda.z i
    sta (__5),y
    // for( word i: 0..499)
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
    // SCREEN[i] = points[i]
    lda.z i1
    asl
    sta.z __3
    lda.z i1+1
    rol
    sta.z __3+1
    lda.z __3
    clc
    adc #<points
    sta.z __6
    lda.z __3+1
    adc #>points
    sta.z __6+1
    clc
    lda.z __7
    adc #<SCREEN
    sta.z __7
    lda.z __7+1
    adc #>SCREEN
    sta.z __7+1
    ldy #0
  !:
    lda (__6),y
    sta (__7),y
    iny
    cpy #SIZEOF_STRUCT_POINT
    bne !-
    // for( word i: 0..499)
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
    // }
    rts
}
  points: .fill 2*$1f4, 0
