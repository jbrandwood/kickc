// Minimal struct - modifying pointer to struct in memory using arrow operator
  // Commodore 64 PRG executable file
.file [name="struct-ptr-13.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_POINT_Y = 1
  .label points = $1000
.segment Code
main: {
    .label SCREEN = $400
    // points->x += 5
    lda #5
    clc
    adc points
    sta points
    // points->y += 5
    lda #5
    clc
    adc points+OFFSET_STRUCT_POINT_Y
    sta points+OFFSET_STRUCT_POINT_Y
    // SCREEN[0] = points->x
    lda points
    sta SCREEN
    // SCREEN[1] = points->y
    lda points+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
