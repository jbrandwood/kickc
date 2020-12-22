// Minimal struct with MemberUnwind behavior - simple members and local initializer
  // Commodore 64 PRG executable file
.file [name="struct-31.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .const point1_x = 2
    .const point1_y = 3
    // SCREEN[0] = point1.x
    lda #point1_x
    sta SCREEN
    // SCREEN[1] = point1.y
    lda #point1_y
    sta SCREEN+1
    // }
    rts
}
