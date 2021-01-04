// Test a constant with multiplication and division
  // Commodore 64 PRG executable file
.file [name="const-mult-div.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const b = 6*$e/3+mod($16,3)
    .label screen = $400
    // screen[0] = b
    lda #b
    sta screen
    // }
    rts
}
