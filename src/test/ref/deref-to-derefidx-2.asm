// Tests optimizing derefs of *(ptr+b) to ptr[b - even when a noop-cast is needed
  // Commodore 64 PRG executable file
.file [name="deref-to-derefidx-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
  .label screen_idx = 2
.segment Code
main: {
    // print(msg1)
    lda #0
    sta.z screen_idx
    lda #<msg1
    sta.z print.m
    lda #>msg1
    sta.z print.m+1
    jsr print
    // print(msg2)
    lda #<msg2
    sta.z print.m
    lda #>msg2
    sta.z print.m+1
    jsr print
    // }
    rts
}
// void print(__zp(3) char *m)
print: {
    .label m = 3
    // SCREEN[screen_idx++] = *(word*)(m+2)
    lda.z screen_idx
    asl
    ldy #2
    tax
    lda (m),y
    sta SCREEN,x
    iny
    lda (m),y
    sta SCREEN+1,x
    // SCREEN[screen_idx++] = *(word*)(m+2);
    inc.z screen_idx
    // }
    rts
}
.segment Data
  msg1: .byte 'a', 'b', 'c', 'd'
  msg2: .byte '1', '2', '3', '4'
