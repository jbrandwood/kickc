// Test void pointer - issues when assigning returns from malloc()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label heap_head = 2
main: {
    .label buf1 = 4
    .label buf2 = 6
    lda #<$c000
    sta heap_head
    lda #>$c000
    sta heap_head+1
    jsr malloc
    lda malloc.return_2
    sta malloc.return
    lda malloc.return_2+1
    sta malloc.return+1
    jsr malloc
    lda #'a'
    ldy #0
    sta (buf1),y
    lda #'b'
    sta (buf2),y
    lda (buf1),y
    sta SCREEN
    lda (buf2),y
    sta SCREEN+1
    rts
}
malloc: {
    .label return = 4
    .label return_1 = 6
    .label return_2 = 6
    inc heap_head
    bne !+
    inc heap_head+1
  !:
    lda heap_head
    sta return_2
    lda heap_head+1
    sta return_2+1
    rts
}
