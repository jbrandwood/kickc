// Illustrates introducing local scopes inside loops etc
  // Commodore 64 PRG executable file
.file [name="localscope-loops.prg", type="prg", segments="Program"]
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
    // SCREEN[i] = 'a'
    lda #'a'
    sta SCREEN,x
    // for (byte i: 0..5)
    inx
    cpx #6
    bne __b1
    ldx #0
  __b2:
    // SCREEN[40+i] = 'b'
    lda #'b'
    sta SCREEN+$28,x
    // for (byte i: 0..5)
    inx
    cpx #6
    bne __b2
    // }
    rts
}
