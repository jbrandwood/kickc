// Test declaring an integer array variable as at a hard-coded address
  // Commodore 64 PRG executable file
.file [name="address-9.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // The screen
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = DATA[0]
    lda DATA
    sta SCREEN
    lda DATA+1
    sta SCREEN+1
    // }
    rts
}
.segment Data
.pc = $1000 "DATA"
  // Data to be put on the screen
  DATA: .fill 2*$3e8, 0
