// Test that a nomodify parameter works
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // print('a')
    lda #'a'
    jsr print
    // print('b')
    lda #'b'
    jsr print
    // }
    rts
}
// print(byte register(A) c)
print: {
    // *SCREEN = c
    sta SCREEN
    // }
    rts
}
