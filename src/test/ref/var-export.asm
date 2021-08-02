// Test the __export directive usable for ensuring a data variable is always added to the output - even if it is never used
  // Commodore 64 PRG executable file
.file [name="var-export.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = 'x'
    lda #'x'
    sta SCREEN
    // }
    rts
}
.segment Data
  MESSAGE: .text "camelot!"
  .byte 0
