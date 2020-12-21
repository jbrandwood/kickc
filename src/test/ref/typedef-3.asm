// Typedef an array
  // Commodore 64 PRG executable file
.file [name="typedef-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  __b1:
    // SCREEN[i] = a[i]
    lda a,x
    sta SCREEN,x
    // for(char i:0..6)
    inx
    cpx #7
    bne __b1
    // }
    rts
}
.segment Data
  a: .text "cml"
  .byte 0
  .fill 3, 0
