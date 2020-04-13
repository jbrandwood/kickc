// Experiments with malloc() - a byte array
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  // Top of the heap used by malloc()
  .label HEAP_TOP = $a000
  .label BYTES = malloc.return
__bbegin:
  // malloc(0x100)
  jsr malloc
  jsr main
  rts
main: {
    ldx #0
  __b1:
    // BYTES[i] = i
    txa
    sta BYTES,x
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
    .const size = $100
    .label mem = HEAP_TOP-size
    .label return = mem
    rts
}
