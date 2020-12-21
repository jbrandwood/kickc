// Tests anonymous scopes inside functions
  // Commodore 64 PRG executable file
.file [name="localscope-simple.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label BG_COLOR = $d021
.segment Code
main: {
    .const i = 0
    .const i1 = 1
    // *BG_COLOR = i
    lda #i
    sta BG_COLOR
    lda #i1
    sta BG_COLOR
    // }
    rts
}
