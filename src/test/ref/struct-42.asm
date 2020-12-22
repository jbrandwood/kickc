// Minimal struct with C-Standard behavior - copying into a struct array
  // Commodore 64 PRG executable file
.file [name="struct-42.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
.segment Code
main: {
    .label i = 2
    lda #0
    sta.z i
  __b1:
    // points[i] = { 2, 3 }
    lda.z i
    asl
    tax
    ldy #0
  !:
    lda __0,y
    sta points,x
    inx
    iny
    cpy #SIZEOF_STRUCT_POINT
    bne !-
    // for( char i: 0..2)
    inc.z i
    lda #3
    cmp.z i
    bne __b1
    // SCREEN[0] = points[2].x
    lda points+2*SIZEOF_STRUCT_POINT
    sta SCREEN
    // SCREEN[1] = points[2].y
    lda points+2*SIZEOF_STRUCT_POINT+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
.segment Data
  points: .fill 2*3, 0
  __0: .byte 2, 3
