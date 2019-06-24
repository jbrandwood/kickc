// Test void pointer - issues when assigning returns from malloc()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label heap_head = 2
main: {
    lda #<$c000
    sta heap_head
    lda #>$c000
    sta heap_head+1
    jsr malloc
    jsr malloc
    lda #'a'
    ldy #0
    sta (heap_head),y
    lda #'b'
    sta (heap_head),y
    lda (heap_head),y
    sta SCREEN
    lda (heap_head),y
    sta SCREEN+1
    rts
}
malloc: {
    inc heap_head
    bne !+
    inc heap_head+1
  !:
    rts
}
