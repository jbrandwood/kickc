// Test declaring an address as expression
  // Commodore 64 PRG executable file
.file [name="address-with-expression-value.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const var1 = $800
  .const var2 = $900
  // The screen
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = DATA[0]
    lda DATA
    sta SCREEN
    // }
    rts
}
.segment Data
.pc = var1+var2 "DATA"
  // Data to be put on the screen
  DATA: .fill $3e8, 0
