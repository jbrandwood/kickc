// Minimal struct with C-Standard behavior - member is array, copy assignment
  // Commodore 64 PRG executable file
.file [name="struct-26.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_POINT = 3
  .const OFFSET_STRUCT_POINT_INITIALS = 1
  .label SCREEN = $400
.segment Code
main: {
    .label point1 = 2
    .label point2 = 5
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
    // point1.initials[0] = 'j'
    lda #'j'
    sta point1+OFFSET_STRUCT_POINT_INITIALS
    // point1.initials[1] = 'g'
    lda #'g'
    sta point1+OFFSET_STRUCT_POINT_INITIALS+1
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
    // SCREEN[1] = point2.initials[0]
    lda point2+OFFSET_STRUCT_POINT_INITIALS
    sta SCREEN+1
    // SCREEN[2] = point2.initials[1]
    lda point2+OFFSET_STRUCT_POINT_INITIALS+1
    sta SCREEN+2
    // }
    rts
}
