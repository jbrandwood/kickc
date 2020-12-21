// Minimal struct -  array with 256+ structs
  // Commodore 64 PRG executable file
.file [name="struct-ptr-10.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
.segment Code
main: {
    .label SCREEN = $400
    .label __2 = 6
    .label __3 = 8
    .label __5 = 6
    .label i = 2
    .label i1 = 4
    .label __6 = $a
    .label __7 = 8
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
    clc
    lda.z __5
    adc #<points
    sta.z __5
    lda.z __5+1
    adc #>points
    sta.z __5+1
    lda #2
    ldy #0
    sta (__5),y
    ldy #OFFSET_STRUCT_POINT_Y
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
    clc
    lda.z __3
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
.segment Data
  points: .fill 2*$1f4, 0
