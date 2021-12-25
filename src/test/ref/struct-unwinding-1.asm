// Test combining unwind structs with classic structs
  // Commodore 64 PRG executable file
.file [name="struct-unwinding-1.prg", type="prg", segments="Program"]
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
    .label p1 = 2
    // __ma struct Point p1 = { 1, 2 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta p1-1,y
    dey
    bne !-
    // SCREEN[0] = p1
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda p1-1,y
    sta SCREEN-1,y
    dey
    bne !-
    // struct Point p2 = p1
    lda.z p1
    ldx.z p1+OFFSET_STRUCT_POINT_Y
    // SCREEN[2] = p2
    sta SCREEN+2*SIZEOF_STRUCT_POINT
    stx SCREEN+2*SIZEOF_STRUCT_POINT+OFFSET_STRUCT_POINT_Y
    // p1.x = 3
    // Set in classic struct
    lda #3
    sta.z p1
    // SCREEN[4] = p1
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda p1-1,y
    sta SCREEN+4*SIZEOF_STRUCT_POINT-1,y
    dey
    bne !-
    // SCREEN[6] = p2
    lda #4
    sta SCREEN+6*SIZEOF_STRUCT_POINT
    stx SCREEN+6*SIZEOF_STRUCT_POINT+OFFSET_STRUCT_POINT_Y
    // p1 = p2
    sta.z p1
    stx.z p1+OFFSET_STRUCT_POINT_Y
    // SCREEN[8] = p1
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda p1-1,y
    sta SCREEN+8*SIZEOF_STRUCT_POINT-1,y
    dey
    bne !-
    // }
    rts
}
.segment Data
  __0: .byte 1, 2
