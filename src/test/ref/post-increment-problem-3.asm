// Illustrates a problem with post-incrementing inside the while loop condition
// https://gitlab.com/camelot/kickc/-/issues/486
  // Commodore 64 PRG executable file
.file [name="post-increment-problem-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // unsigned char n = *(ptr++)
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
.segment Data
  mmap: .byte 2, $5c, $1a, 3, $60, $1a, 7
