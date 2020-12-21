  // Commodore 64 PRG executable file
.file [name="typedef-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_POINTDEF_Y = 1
.segment Code
main: {
    .const p_x = 4
    .const p_y = 7
    .label SCREEN = $400
    // *SCREEN = p
    lda #p_x
    sta SCREEN
    lda #p_y
    sta SCREEN+OFFSET_STRUCT_POINTDEF_Y
    // }
    rts
}
