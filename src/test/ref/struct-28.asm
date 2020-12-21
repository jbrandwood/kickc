// Minimal struct with C-Standard behavior - member is array, copy assignment
  // Commodore 64 PRG executable file
.file [name="struct-28.prg", type="prg", segments="Program"]
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
    // point1 = { 2, { 'j', 'g' } }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta point1-1,y
    dey
    bne !-
    // SCREEN[0] = point1.x
    lda.z point1
    sta SCREEN
    // SCREEN[1] = point1.initials[0]
    lda point1+OFFSET_STRUCT_POINT_INITIALS
    sta SCREEN+1
    // SCREEN[2] = point1.initials[1]
    lda point1+OFFSET_STRUCT_POINT_INITIALS+1
    sta SCREEN+2
    // }
    rts
}
.segment Data
  __0: .byte 2, 'j', 'g'
