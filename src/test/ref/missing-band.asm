// Demonstrates missing fragment
// https://gitlab.com/camelot/kickc/-/issues/293
  // Commodore 64 PRG executable file
.file [name="missing-band.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label a = 2
    // foo(1)
    jsr foo
    // a=(foo(1) & 3)
    and #3
    sta.z a
    lda #0
    sta.z a+1
    // *SCREEN = (byte)a
    lda.z a
    sta SCREEN
    // }
    rts
}
// __register(A) char foo(char x)
foo: {
    .const x = 1
    // return bar[x];
    lda bar+x
    // }
    rts
}
.segment Data
  bar: .byte 9, 1, 2, 3, 4, 5, 6, 7, 8, 9
