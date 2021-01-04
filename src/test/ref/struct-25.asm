// Minimal struct with C-Standard behavior - member array sizeof
  // Commodore 64 PRG executable file
.file [name="struct-25.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_POINT = 4
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = sizeof(struct Point)
    lda #SIZEOF_STRUCT_POINT
    sta SCREEN
    // }
    rts
}
