// Test of simple enum - char values with increment
  // Commodore 64 PRG executable file
.file [name="enum-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const B = 'b'
.segment Code
main: {
    .label SCREEN = $400
    // *SCREEN = letter
    lda #B
    sta SCREEN
    // }
    rts
}
