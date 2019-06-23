// Experiments with malloc() - a word array
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  // Start of the heap used by malloc()
  .label HEAP_START = $c000
bbegin:
  jsr malloc
  jsr main
  rts
main: {
    .label w = 2
    lda #<HEAP_START
    sta w
    lda #>HEAP_START
    sta w+1
    ldx #0
  b1:
    txa
    ldy #0
    sta (w),y
    tya
    iny
    sta (w),y
    lda #SIZEOF_WORD
    clc
    adc w
    sta w
    bcc !+
    inc w+1
  !:
    inx
    cpx #0
    bne b1
    rts
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
malloc: {
    rts
}
