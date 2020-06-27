// Experiments with malloc() - a word array
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  .label WORDS = malloc.return
__start: {
    // malloc(0x200)
    jsr malloc
    jsr main
    rts
}
main: {
    .label w = 2
    lda #<WORDS
    sta.z w
    lda #>WORDS
    sta.z w+1
    ldx #0
  __b1:
    // *w++ = i
    txa
    ldy #0
    sta (w),y
    tya
    iny
    sta (w),y
    // *w++ = i;
    lda #SIZEOF_WORD
    clc
    adc.z w
    sta.z w
    bcc !+
    inc.z w+1
  !:
    // for( byte i: 0..255)
    inx
    cpx #0
    bne __b1
    // }
    rts
}
// Allocates a block of size chars of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
malloc: {
    .const size = $200
    .label mem = HEAP_TOP-size
    .label return = mem
    rts
}
