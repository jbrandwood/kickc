// Test memory model
// Demonstrates problem where post-increase on __ma memory variables is performed to early
  // Commodore 64 PRG executable file
.file [name="varmodel-ma_mem-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // i=0
    lda #0
    sta i
  __b1:
    // SCREEN[i] = '*'
    lda #'*'
    ldy i
    sta SCREEN,y
    // i++<4
    tya
    // while(i++<4)
    inc i
    cmp #4
    bcc __b1
    // }
    rts
  .segment Data
    i: .byte 0
}
