// Minimal struct -  array access with struct value copying (and initializing)
  // Commodore 64 PRG executable file
.file [name="struct-ptr-9.prg", type="prg", segments="Program"]
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
    .label i1 = 2
    ldy #0
  __b1:
    // points[i] = { 2, i }
    tya
    asl
    tax
    lda #2
    sta points,x
    tya
    sta points+OFFSET_STRUCT_POINT_Y,x
    // for( byte i: 0..1)
    iny
    cpy #2
    bne __b1
    lda #0
    sta.z i1
  __b2:
    // SCREEN[i] = points[i]
    lda.z i1
    asl
    ldx #SIZEOF_STRUCT_POINT
    tay
  !:
    lda points,y
    sta SCREEN,y
    iny
    dex
    bne !-
    // for( byte i: 0..1)
    inc.z i1
    lda #2
    cmp.z i1
    bne __b2
    // }
    rts
}
.segment Data
  points: .fill 2*2, 0
