// Minimal struct with C-Standard behavior - address-of
  // Commodore 64 PRG executable file
.file [name="struct-21.prg", type="prg", segments="Program"]
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
    .label ptr = point1
    .label point1 = 2
    // __ma struct Point point1 = { 2, 3 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta point1-1,y
    dey
    bne !-
    // SCREEN[0] = ptr->x
    lda.z ptr
    sta SCREEN
    // SCREEN[1] = ptr->y
    lda.z ptr+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
.segment Data
  __0: .byte 2, 3
