// Demonstrates a problem where constant references are not literal
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label B = $8000
main: {
    // copy(B, A)
    jsr copy
    // }
    rts
}
// Copy a byte if the destination is after the source
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
  A: .text "qwe"
  .byte 0
