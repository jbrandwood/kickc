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
    lax points
    axs #-[5]
    stx points
    // points->y += 5
    lax points+OFFSET_STRUCT_POINT_Y
    axs #-[5]
    stx points+OFFSET_STRUCT_POINT_Y
    // SCREEN[0] = points->x
    lda points
    sta SCREEN
    // SCREEN[1] = points->y
    txa
    sta SCREEN+1
    // }
    rts
}
