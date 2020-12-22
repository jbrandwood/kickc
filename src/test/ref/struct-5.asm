// Minimal struct - struct return value
  // Commodore 64 PRG executable file
.file [name="struct-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // point()
    jsr point
    // SCREEN[0] = q.x
    lda #point.p_x
    sta SCREEN
    // SCREEN[1] = q.y
    lda #point.p_y
    sta SCREEN+1
    // }
    rts
}
point: {
    .label p_x = 2
    .label p_y = 3
    rts
}
