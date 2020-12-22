// Some bool code that causes a NullPointerException
  // Commodore 64 PRG executable file
.file [name="bool-nullpointer-exception.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    lda #1
    jmp __b2
  __b1:
    lda #0
  __b2:
    // while(!framedone)
    cmp #0
    bne __b1
    jmp __b2
}
