// Experiments with malloc() - a byte array
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  // Start of the heap used by malloc()
  .label HEAP_START = $c000
bbegin:
  jsr malloc
  jsr main
  rts
main: {
    ldx #0
  b1:
    txa
    sta HEAP_START,x
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
