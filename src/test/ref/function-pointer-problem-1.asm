// The following casuses an exception in pass 2
// https://gitlab.com/camelot/kickc/-/issues/561
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label r = $8000
fn1: {
    // *r = 1
    lda #1
    sta r
    // }
    rts
}
main: {
    // enableDLI(&fn1)
    jsr enableDLI
    // }
    rts
}
// enableDLI(void*  dliptr)
enableDLI: {
    .label dliptr = fn1
    // asm
    lda #<dliptr
    sta dlivec
    lda #>dliptr
    sta dlivec+1
    jmp !+
  dlivec:
    .byte 0, 0
  !:
    // }
    rts
}
