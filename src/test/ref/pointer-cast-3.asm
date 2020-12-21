// Tests casting pointer types to other pointer types
  // Commodore 64 PRG executable file
.file [name="pointer-cast-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const sb = $ff
    .label sb_screen = $400
    // *sb_screen = sb
    lda #sb
    sta sb_screen
    // }
    rts
}
