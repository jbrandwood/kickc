// The following casuses an exception in pass 2
// https://gitlab.com/camelot/kickc/-/issues/561
  // Commodore 64 PRG executable file
.file [name="function-pointer-problem-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label r = $8000
.segment Code
fn1: {
    // *r = 1
    lda #1
    sta r
    // }
    rts
}
main: {
    // enableDLI(&fn1)
    lda #<fn1
    sta.z enableDLI.dliptr
    lda #>fn1
    sta.z enableDLI.dliptr+1
    jsr enableDLI
    // }
    rts
}
// void enableDLI(__zp(2) void * volatile dliptr)
enableDLI: {
    .label dliptr = 2
    // asm
    lda dliptr
    sta dlivec
    lda dliptr+1
    sta dlivec+1
    jmp !+
  dlivec:
    .byte 0, 0
  !:
    // }
    rts
}
