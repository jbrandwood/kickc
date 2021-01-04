// Minimal struct with C-Standard behavior - copy assignment through struct pointer
  // Commodore 64 PRG executable file
.file [name="struct-35.prg", type="prg", segments="Program"]
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
    .label p2 = point2
    // *p2 = point1
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda point1-1,y
    sta p2-1,y
    dey
    bne !-
    // SCREEN[0] = point2.x
    lda point2
    sta SCREEN
    // SCREEN[1] = point2.y
    lda point2+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
.segment Data
  point1: .byte 2, 3
  point2: .fill SIZEOF_STRUCT_POINT, 0
