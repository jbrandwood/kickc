// Minimal struct with C-Standard behavior - global main-mem struct should be initialized in data, not code
  // Commodore 64 PRG executable file
.file [name="struct-36.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_POINT_INITIALS = 1
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = point1.x
    lda point1
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
  point1: .byte 2
  .text "jg"
  .byte 0
