// Minimal struct - direct (constant) array access
  // Commodore 64 PRG executable file
.file [name="struct-ptr-7.prg", type="prg", segments="Program"]
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
    // points[0].x = 2
    lda #2
    sta points
    // points[0].y = 3
    lda #3
    sta points+OFFSET_STRUCT_POINT_Y
    // points[1].x = 5
    lda #5
    sta points+1*SIZEOF_STRUCT_POINT
    // points[1].y = 6
    lda #6
    sta points+1*SIZEOF_STRUCT_POINT+OFFSET_STRUCT_POINT_Y
    // SCREEN[0] = points[0].x
    lda points
    sta SCREEN
    // SCREEN[1] = points[0].y
    lda points+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // SCREEN[3] = points[1].x
    lda points+1*SIZEOF_STRUCT_POINT
    sta SCREEN+3
    // SCREEN[4] = points[1].y
    lda points+1*SIZEOF_STRUCT_POINT+OFFSET_STRUCT_POINT_Y
    sta SCREEN+4
    // }
    rts
}
.segment Data
  points: .fill 2*2, 0
