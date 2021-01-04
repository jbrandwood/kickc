// Test an array with mixed byte/number types
  // Commodore 64 PRG executable file
.file [name="mixed-array-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[0] = msg[0]
    lda msg
    sta SCREEN
    // SCREEN[1] = msg[1]
    lda msg+1
    sta SCREEN+1
    // SCREEN[2] = msg[2]
    lda msg+2
    sta SCREEN+2
    // }
    rts
  .segment Data
    msg: .byte -1, 0, 1
}
