// Minimal struct - initializing using a value list
  // Commodore 64 PRG executable file
.file [name="struct-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const x = 2
    .const y = 3
    .const p_y = y+1
    .label SCREEN = $400
    // SCREEN[0] = p.x
    lda #x
    sta SCREEN
    // SCREEN[1] = p.y
    lda #p_y
    sta SCREEN+1
    // }
    rts
}
