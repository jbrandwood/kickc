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
    sta.z heap_head
    lda #>$c000
    sta.z heap_head+1
    jsr malloc
    lda.z malloc.return_2
    sta.z malloc.return
    lda.z malloc.return_2+1
    sta.z malloc.return+1
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
    inc.z heap_head
    bne !+
    inc.z heap_head+1
  !:
    lda.z heap_head
    sta.z return_2
    lda.z heap_head+1
    sta.z return_2+1
    rts
}
