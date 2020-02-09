// Experiments with malloc()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  // Head of the heap. Moved backward each malloc()
  .label heap_head = 2
main: {
    .label screen = $400
    .label buf1 = 4
    .label buf2 = 6
    lda #<HEAP_TOP
    sta.z heap_head
    lda #>HEAP_TOP
    sta.z heap_head+1
    jsr malloc
    lda.z malloc.mem
    sta.z buf1
    lda.z malloc.mem+1
    sta.z buf1+1
    jsr malloc
    ldy #0
  __b1:
    tya
    sta (buf1),y
    tya
    eor #$ff
    clc
    adc #$ff+1
    sta (buf2),y
    iny
    cpy #$64
    bne __b1
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
    lda.z heap_head
    sec
    sbc #<$64
    sta.z mem
    lda.z heap_head+1
    sbc #>$64
    sta.z mem+1
    lda.z mem
    sta.z heap_head
    lda.z mem+1
    sta.z heap_head+1
    rts
}
