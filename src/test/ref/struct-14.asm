// Minimal struct with C-Standard behavior - declaration, instantiation and usage
  // Commodore 64 PRG executable file
.file [name="struct-14.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
.segment Code
main: {
    // points[0].x = 2
    lda #2
    sta points
    // points[0].y = 3
    lda #3
    sta points+OFFSET_STRUCT_POINT_Y
    // SCREEN[0] = points[0].x
    lda points
    sta SCREEN
    // SCREEN[1] = points[0].y
    lda points+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
.segment Data
  points: .fill 2*1, 0
