// Test compile-time and run-time multiplication
// Compile-time multiplication
  // Commodore 64 PRG executable file
.file [name="multiply-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .const c1 = 4
    .const c3 = c1*(c1*2+1)
    // SCREEN[0] = c3
    lda #c3
    sta SCREEN
    // }
    rts
}
