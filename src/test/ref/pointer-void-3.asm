// Test void pointer - issues when assigning returns from malloc()
  // Commodore 64 PRG executable file
.file [name="pointer-void-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
  .label heap_head = 2
.segment Code
main: {
    .label buf1 = 4
    .label buf2 = 6
    // byte* buf1 = malloc()
    lda #<$c000
    sta.z heap_head
    lda #>$c000
    sta.z heap_head+1
    jsr malloc
    // byte* buf1 = malloc()
    lda.z malloc.return_1
    sta.z malloc.return
    lda.z malloc.return_1+1
    sta.z malloc.return+1
    // byte* buf2 = malloc()
    jsr malloc
    // byte* buf2 = malloc()
    // *buf1 = 'a'
    lda #'a'
    ldy #0
    sta (buf1),y
    // *buf2 = 'b'
    lda #'b'
    sta (buf2),y
    // SCREEN[0] = *buf1
    lda (buf1),y
    sta SCREEN
    // SCREEN[1] = *buf2
    lda (buf2),y
    sta SCREEN+1
    // }
    rts
}
malloc: {
    .label return = 4
    .label return_1 = 6
    // heap_head++;
    inc.z heap_head
    bne !+
    inc.z heap_head+1
  !:
    // return heap_head;
    lda.z heap_head
    sta.z return_1
    lda.z heap_head+1
    sta.z return_1+1
    // }
    rts
}
