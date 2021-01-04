// Struct - forced __ssa
  // Commodore 64 PRG executable file
.file [name="struct-34.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const point_x = 2
  .const point_y = 3
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = point.x
    lda #point_x
    sta SCREEN
    // SCREEN[1] = point.y
    lda #point_y
    sta SCREEN+1
    // }
    rts
}
