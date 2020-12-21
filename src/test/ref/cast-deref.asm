// Example of NOP-casting a dereferenced signed byte to a byte
  // Commodore 64 PRG executable file
.file [name="cast-deref.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // SCREEN[i] = (byte) sbs[i]
    lda sbs,x
    sta SCREEN,x
    // for(byte i : 0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
  .segment Data
    sbs: .byte -1, -2, -3, -4
}
