  // Commodore 64 PRG executable file
.file [name="lobyte-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label VDP_REG = $a001
.segment Code
main: {
    .const addr = 3
    // TMS_WRITE_CTRL_PORT
    lda #<addr
    sta VDP_REG
    // }
    rts
}
