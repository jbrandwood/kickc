// Test typedef enum
  // Commodore 64 PRG executable file
.file [name="typedef-8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const FALSE = 0
  .label SCREEN = $400
.segment Code
main: {
    // *SCREEN = exe
    lda #FALSE
    sta SCREEN
    // }
    rts
}
