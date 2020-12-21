// Minimal struct - two instances being used.
  // Commodore 64 PRG executable file
.file [name="struct-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_POINT_Y = 1
  .const SIZEOF_STRUCT_POINT = 2
.segment Code
main: {
    .label SCREEN = $400
    // point1.x = 2
    lda #2
    sta point1
    // point1.y = 3
    lda #3
    sta point1+OFFSET_STRUCT_POINT_Y
    // point2.x = point1.y
    sta point2
    // point2.y = point1.x
    lda point1
    sta point2+OFFSET_STRUCT_POINT_Y
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
  point1: .fill SIZEOF_STRUCT_POINT, 0
  point2: .fill SIZEOF_STRUCT_POINT, 0
