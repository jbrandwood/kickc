// Demonstrates a problem where constant references are not literal
  // Commodore 64 PRG executable file
.file [name="constref-not-literal-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label B = $8000
.segment Code
main: {
    // copy(B, A)
    jsr copy
    // }
    rts
}
// Copy a byte if the destination is after the source
// void copy(void *destination, void *source)
copy: {
    .label destination = B
    .label source = A
    .label src = source
    .label dst = destination
    // if((unsigned int)destination>(unsigned int)source)
    lda #>destination
    cmp #>source
    bne !+
    lda #<destination
    cmp #<source
    beq __breturn
  !:
    bcc __breturn
    // *dst = *src
    lda src
    sta dst
  __breturn:
    // }
    rts
}
.segment Data
  A: .text "qwe"
  .byte 0
