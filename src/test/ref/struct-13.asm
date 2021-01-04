// Minimal struct with C-Standard behavior - declaration, instantiation and usage
  // Commodore 64 PRG executable file
.file [name="struct-13.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_POINT_Y = 1
  .const SIZEOF_STRUCT_POINT = 2
  .label SCREEN = $400
.segment Code
main: {
    // point.x = 2
    lda #2
    sta point
    // point.y = 3
    lda #3
    sta point+OFFSET_STRUCT_POINT_Y
    // SCREEN[0] = point.x
    lda point
    sta SCREEN
    // SCREEN[1] = point.y
    lda point+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
.segment Data
  point: .fill SIZEOF_STRUCT_POINT, 0
