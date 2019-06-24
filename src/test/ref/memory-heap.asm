// Experiments with malloc()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Start of the heap used by malloc()
  .label HEAP_START = $c000
  .label heap_head = 2
main: {
    .label screen = $400
    .label buf1 = 4
    .label buf2 = 6
    lda #<HEAP_START
    sta heap_head
    lda #>HEAP_START
    sta heap_head+1
    jsr malloc
    lda malloc.mem
    sta buf1
    lda malloc.mem+1
    sta buf1+1
    jsr malloc
    ldy #0
  b1:
    tya
    sta (buf1),y
    tya
    eor #$ff
    clc
    adc #$ff+1
    sta (buf2),y
    iny
    cpy #$64
    bne b1
    jsr free
    jsr free
    ldy #0
    lda (buf1),y
    sta screen
    lda (buf2),y
    sta screen+1
    rts
}
// A block of memory previously allocated by a call to malloc is deallocated, making it available again for further allocations.
// If ptr is a null pointer, the function does nothing.
free: {
    rts
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
malloc: {
    .label mem = 6
    lda heap_head
    sta mem
    lda heap_head+1
    sta mem+1
    lda #$64
    clc
    adc heap_head
    sta heap_head
    bcc !+
    inc heap_head+1
  !:
    rts
}
