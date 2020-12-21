// Tests simple word pointer iteration
  // Commodore 64 PRG executable file
.file [name="word-pointer-iteration-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_WORD = 2
.segment Code
main: {
    .label SCREEN = $400+$28*6
    // <*wp
    lda $400+SIZEOF_WORD
    // SCREEN[0] = <*wp
    sta SCREEN
    // >*wp
    lda $400+SIZEOF_WORD+1
    // SCREEN[1] = >*wp
    sta SCREEN+1
    // <*wp
    lda $400+SIZEOF_WORD+SIZEOF_WORD
    // SCREEN[2] = <*wp
    sta SCREEN+2
    // >*wp
    lda $400+SIZEOF_WORD+SIZEOF_WORD+1
    // SCREEN[3] = >*wp
    sta SCREEN+3
    // <*wp
    lda $400+SIZEOF_WORD+SIZEOF_WORD-SIZEOF_WORD
    // SCREEN[4] = <*wp
    sta SCREEN+4
    // >*wp
    lda $400+SIZEOF_WORD+SIZEOF_WORD-SIZEOF_WORD+1
    // SCREEN[5] = >*wp
    sta SCREEN+5
    // }
    rts
}
