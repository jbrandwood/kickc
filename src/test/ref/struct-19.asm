// Minimal struct with C-Standard behavior - struct containing struct with assignment of sub-struct
  // Commodore 64 PRG executable file
.file [name="struct-19.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_VECTOR = 4
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_VECTOR_Q = 2
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
.segment Code
main: {
    .label v = 2
    .label p1 = 6
    .label p2 = 8
    // __ma struct Vector v
    ldy #SIZEOF_STRUCT_VECTOR
    lda #0
  !:
    dey
    sta v,y
    bne !-
    // __ma struct Point p1 = { 2, 3 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta p1-1,y
    dey
    bne !-
    // __ma struct Point p2 = { 4, 5 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __1-1,y
    sta p2-1,y
    dey
    bne !-
    // v.p = p1
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda p1-1,y
    sta v-1,y
    dey
    bne !-
    // v.q = p2
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda p2-1,y
    sta v+OFFSET_STRUCT_VECTOR_Q-1,y
    dey
    bne !-
    // SCREEN[0] = v.p.x
    lda.z v
    sta SCREEN
    // SCREEN[1] = v.p.y
    lda.z v+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // SCREEN[2] = v.q.x
    lda.z v+OFFSET_STRUCT_VECTOR_Q
    sta SCREEN+2
    // SCREEN[3] = v.q.y
    lda.z v+OFFSET_STRUCT_VECTOR_Q+OFFSET_STRUCT_POINT_Y
    sta SCREEN+3
    // }
    rts
}
.segment Data
  __0: .byte 2, 3
  __1: .byte 4, 5
