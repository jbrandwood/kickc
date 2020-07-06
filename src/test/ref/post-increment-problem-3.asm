// Illustrates a problem with post-incrementing inside the while loop condition
// https://gitlab.com/camelot/kickc/-/issues/486
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // n = *(ptr++)
    lda mmap
  __b1:
    // while (n--)
    tax
    dex
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // *((unsigned char *)0x400) = n
    stx $400
    txa
    jmp __b1
}
  mmap: .byte 2, $5c, $1a, 3, $60, $1a, 7
