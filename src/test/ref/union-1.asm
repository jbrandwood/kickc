// Minimal union with C-Standard behavior - union nested inside struct
  // Commodore 64 PRG executable file
.file [name="union-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const WORD = 1
  .const OFFSET_STRUCT_JIG_DATA = 1
  .const SIZEOF_STRUCT_JIG = 3
  .label SCREEN = $400
.segment Code
main: {
    // jig.type = WORD
    lda #WORD
    sta jig
    // jig.data.w = 1234
    lda #<$4d2
    sta jig+OFFSET_STRUCT_JIG_DATA
    lda #>$4d2
    sta jig+OFFSET_STRUCT_JIG_DATA+1
    // SCREEN[0] = jig.type
    lda jig
    sta SCREEN
    // SCREEN[0] = jig.data.b
    lda jig+OFFSET_STRUCT_JIG_DATA
    sta SCREEN
    // }
    rts
}
.segment Data
  jig: .fill SIZEOF_STRUCT_JIG, 0
