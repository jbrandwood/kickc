// Demonstrates missing fragment
// https://gitlab.com/camelot/kickc/-/issues/293
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
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
foo: {
    .const x = 1
    // return bar[x];
    lda bar+x
    // }
    rts
}
  bar: .byte 9, 1, 2, 3, 4, 5, 6, 7, 8, 9
