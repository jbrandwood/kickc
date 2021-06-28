// Error cleaning up unused blocks
  // Commodore 64 PRG executable file
.file [name="emptyblock-error.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label B = $1000
.segment Code
main: {
  __b1:
    // menu()
    jsr menu
    jmp __b1
}
menu: {
    // mode()
    jsr mode
    // }
    rts
}
mode: {
  __b1:
    // if(*B == 0)
    lda B
    bne __b1
    jmp __b1
}
