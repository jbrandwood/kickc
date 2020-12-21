// Minimal struct - accessing pointer to struct in memory using arrow operator
  // Commodore 64 PRG executable file
.file [name="struct-ptr-6.prg", type="prg", segments="Program"]
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
    // SCREEN[0] = points->x
    lda $1000
    sta SCREEN
    // SCREEN[1] = points->y
    lda $1000+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // SCREEN[2] = points->x
    lda $1000+SIZEOF_STRUCT_POINT
    sta SCREEN+2
    // SCREEN[3] = points->y
    lda $1000+SIZEOF_STRUCT_POINT+OFFSET_STRUCT_POINT_Y
    sta SCREEN+3
    // }
    rts
}
