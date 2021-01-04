  // Commodore 64 PRG executable file
.file [name="test-comments-loop.prg", type="prg", segments="Program"]
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
  // Do some sums
  __b1:
    // SCREEN[b] = 'a'
    lda #'a'
    sta SCREEN,x
    // for(byte b: 0..10 )
    inx
    cpx #$b
    bne __b1
    // }
    rts
}
