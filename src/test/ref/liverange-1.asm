// Test propagation of live ranges back over PHI-calls
// The idx-variable is alive between the two calls to out() - but not before the first call.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // out('c')
    ldx #0
    lda #'c'
    jsr out
    // out('m')
    lda #'m'
    jsr out
    // }
    rts
}
// out(byte register(A) c)
out: {
    // SCREEN[idx++] = c
    sta SCREEN,x
    // SCREEN[idx++] = c;
    inx
    // }
    rts
}
