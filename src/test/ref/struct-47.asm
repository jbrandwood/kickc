// https://gitlab.com/camelot/kickc/-/issues/588
// Struct offset calculation is ignoring the high byte
  // Commodore 64 PRG executable file
.file [name="struct-47.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT___OS_DCB = $100
  .const OFFSET_STRUCT___DCB_DUNIT = 1
.segment Code
main: {
    // OS.dcb.ddevic = 1
    lda #1
    sta 0+OFFSET_STRUCT___OS_DCB
    // OS.dcb.dunit = 2
    lda #2
    sta 0+OFFSET_STRUCT___OS_DCB+OFFSET_STRUCT___DCB_DUNIT
    // }
    rts
}
