// Tests the sizeof() operator on structs
  // Commodore 64 PRG executable file
.file [name="sizeof-struct.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_POINT = 2
  .const SIZEOF_STRUCT_CIRCLE = 3
  .label SCREEN = $400
.segment Code
main: {
    // Struct Arrays
    .const NUM_POINTS = 4
    .const NUM_CIRCLES = NUM_POINTS-1
    // SCREEN[idx++] = '0'+(char)sizeof(struct Point)
    // Struct Types
    lda #'0'+SIZEOF_STRUCT_POINT
    sta SCREEN
    // SCREEN[idx++] = '0'+(char)sizeof(struct Circle)
    lda #'0'+SIZEOF_STRUCT_CIRCLE
    sta SCREEN+1
    // SCREEN[idx++] = '0'+(char)sizeof(p)
    lda #'0'+SIZEOF_STRUCT_POINT
    sta SCREEN+3
    // SCREEN[idx++] = '0'+(char)sizeof(c)
    lda #'0'+SIZEOF_STRUCT_CIRCLE
    sta SCREEN+4
    // SCREEN[idx++] = '0'+(char)sizeof(points)
    lda #'0'+NUM_POINTS*SIZEOF_STRUCT_POINT
    sta SCREEN+6
    // SCREEN[idx++] = '0'+(char)(sizeof(points)/sizeof(struct Point))
    lda #'0'+NUM_POINTS*SIZEOF_STRUCT_POINT/SIZEOF_STRUCT_POINT
    sta SCREEN+7
    // SCREEN[idx++] = '0'+(char)(sizeof(circles))
    lda #'0'+NUM_CIRCLES*SIZEOF_STRUCT_CIRCLE
    sta SCREEN+8
    // SCREEN[idx++] = '0'+(char)(sizeof(circles)/sizeof(struct Circle))
    lda #'0'+NUM_CIRCLES*SIZEOF_STRUCT_CIRCLE/SIZEOF_STRUCT_CIRCLE
    sta SCREEN+9
    // }
    rts
}
