// Minimal struct with C-Standard behavior - call return value (not supported yet)
  // Commodore 64 PRG executable file
.file [name="struct-23.prg", type="prg", segments="Program"]
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
    .label point1 = 2
    .label point2 = 4
    // __ma struct Point point1 = getPoint(2, 3)
    lda #3
    ldx #2
    jsr getPoint
    // __ma struct Point point1 = getPoint(2, 3)
    stx.z point1
    sta point1+OFFSET_STRUCT_POINT_Y
    // SCREEN[0] = point1.x
    txa
    sta SCREEN
    // SCREEN[1] = point1.y
    lda point1+OFFSET_STRUCT_POINT_Y
    sta SCREEN+1
    // __ma struct Point point2 = getPoint(4, 5)
    lda #5
    ldx #4
    jsr getPoint
    // __ma struct Point point2 = getPoint(4, 5)
    stx.z point2
    sta point2+OFFSET_STRUCT_POINT_Y
    // SCREEN[2] = point2.x
    txa
    sta SCREEN+2
    // SCREEN[3] = point2.y
    lda point2+OFFSET_STRUCT_POINT_Y
    sta SCREEN+3
    // }
    rts
}
getPoint: {
    rts
}
