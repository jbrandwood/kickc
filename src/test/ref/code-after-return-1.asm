// Test code after return in main()
  // Commodore 64 PRG executable file
.file [name="code-after-return-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const b = 0
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = b
    lda #b
    sta SCREEN
    // }
    rts
}
