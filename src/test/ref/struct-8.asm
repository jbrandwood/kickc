// Minimal struct - nested struct where a sub-struct is assigned out
  // Commodore 64 PRG executable file
.file [name="struct-8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const p_x = $a
    .const p_y = $a
    .const c_radius = 5
    .label SCREEN = $400
    // SCREEN[0] = point.x
    lda #p_x
    sta SCREEN
    // SCREEN[1] = point.y
    lda #p_y
    sta SCREEN+1
    // SCREEN[1] = c.radius
    lda #c_radius
    sta SCREEN+1
    // }
    rts
}
