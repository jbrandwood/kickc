// Fill screen using a spiral based on distance-to-center / angle-to-center
// Utilizes a bucket sort for identifying the minimum angle/distance
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .const SIZEOF_WORD = 2
  // Start of the heap used by malloc()
  .label HEAP_START = $c000
  .label heap_head = 6
  // Screen containing distance to center
  .label SCREEN_DIST = 2
  // Array containing the bucket size for each of the 256 buckets
  .label BUCKET_SIZES = $a
bbegin:
  lda #<$3e8
  sta malloc.size
  lda #>$3e8
  sta malloc.size+1
  lda #<HEAP_START
  sta heap_head
  lda #>HEAP_START
  sta heap_head+1
  jsr malloc
  lda malloc.mem
  sta SCREEN_DIST
  lda malloc.mem+1
  sta SCREEN_DIST+1
  lda #<$3e8
  sta malloc.size
  lda #>$3e8
  sta malloc.size+1
  jsr malloc
  lda #$80*SIZEOF_WORD
  sta malloc.size
  lda #0
  sta malloc.size+1
  jsr malloc
  jsr main
  rts
main: {
    jsr init_dist_screen
    jsr init_angle_screen
    jsr init_buckets
    rts
}
init_buckets: {
    .label dist = 2
    .label i1 = 4
    ldx #0
  // Init bucket sizes to 0
  b1:
    txa
    asl
    tay
    lda #<0
    sta (BUCKET_SIZES),y
    iny
    sta (BUCKET_SIZES),y
    inx
    cpx #$80
    bne b1
  // first find bucket sizes - by counting number of chars with each distance value
    sta i1
    sta i1+1
  b3:
    ldy #0
    lda (dist),y
    asl
    tay
    lda (BUCKET_SIZES),y
    clc
    adc #1
    sta (BUCKET_SIZES),y
    bne !+
    iny
    lda (BUCKET_SIZES),y
    adc #0
    sta (BUCKET_SIZES),y
  !:
    inc dist
    bne !+
    inc dist+1
  !:
    inc i1
    bne !+
    inc i1+1
  !:
    lda i1+1
    cmp #>$3e8
    bne b3
    lda i1
    cmp #<$3e8
    bne b3
    rts
}
// Populates 1000 bytes (a screen) with values representing the angle to the center.
// Utilizes symmetry around the  center
init_angle_screen: {
    rts
}
// Populates 1000 bytes (a screen) with values representing the distance to the center.
// The actual value stored is distance*2 to increase precision
init_dist_screen: {
    rts
}
// Allocates a block of size bytes of memory, returning a pointer to the beginning of the block.
// The content of the newly allocated block of memory is not initialized, remaining with indeterminate values.
// malloc(word zeropage(8) size)
malloc: {
    .label mem = $a
    .label size = 8
    lda heap_head
    sta mem
    lda heap_head+1
    sta mem+1
    lda heap_head
    clc
    adc size
    sta heap_head
    lda heap_head+1
    adc size+1
    sta heap_head+1
    rts
}
