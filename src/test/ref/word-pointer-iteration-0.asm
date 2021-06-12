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
    // BYTE0(*wp)
    lda $400+SIZEOF_WORD
    // SCREEN[0] = BYTE0(*wp)
    sta SCREEN
    // BYTE1(*wp)
    lda $400+SIZEOF_WORD+1
    // SCREEN[1] = BYTE1(*wp)
    sta SCREEN+1
    // BYTE0(*wp)
    lda $400+SIZEOF_WORD+SIZEOF_WORD
    // SCREEN[2] = BYTE0(*wp)
    sta SCREEN+2
    // BYTE1(*wp)
    lda $400+SIZEOF_WORD+SIZEOF_WORD+1
    // SCREEN[3] = BYTE1(*wp)
    sta SCREEN+3
    // BYTE0(*wp)
    lda $400+SIZEOF_WORD+SIZEOF_WORD-SIZEOF_WORD
    // SCREEN[4] = BYTE0(*wp)
    sta SCREEN+4
    // BYTE1(*wp)
    lda $400+SIZEOF_WORD+SIZEOF_WORD-SIZEOF_WORD+1
    // SCREEN[5] = BYTE1(*wp)
    sta SCREEN+5
    // }
    rts
}
