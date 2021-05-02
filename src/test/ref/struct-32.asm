// Minimal struct with C-Standard behavior - copy assignment
  // Commodore 64 PRG executable file
.file [name="struct-32.prg", type="prg", segments="Program"]
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
    .label point1 = 2
    .label point2 = 4
    // __ma struct Point point1
    ldy #SIZEOF_STRUCT_POINT
    lda #0
  !:
    dey
    sta point1,y
    bne !-
    // point1.x = 2
    lda #2
    sta.z point1
    // point1.y = 3
    lda #3
    sta point1+OFFSET_STRUCT_POINT_Y
    // __ma struct Point point2 = point1
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda point1-1,y
    sta point2-1,y
    dey
    bne !-
    // SCREEN[0] = point2.x
    lda.z point2
    sta SCREEN
    // SCREEN[1] = point2.y
    lda point2+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // }
    rts
}
