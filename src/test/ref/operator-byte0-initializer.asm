// Test operator BYTE0() / BYTE1() in initializers
  // Commodore 64 PRG executable file
.file [name="operator-byte0-initializer.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // SCREEN[i++] = VALS[0]
    lda VALS
    sta SCREEN
    // SCREEN[i++] = VALS[1]
    lda VALS+1
    sta SCREEN+1
    // SCREEN[i++] = VALS[2]
    lda VALS+2
    sta SCREEN+2
    // SCREEN[i++] = VALS[3]
    lda VALS+3
    sta SCREEN+3
    // }
    rts
}
.segment Data
  VALS: .byte <($756b5b3), >($756b5b3), <($756b5b3>>$10), >($756b5b3>>$10)
