// Tests optimizing derefs of *(ptr+b) to ptr[b - even when a noop-cast is needed
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label screen_idx = 4
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
// print(byte* zp(2) m)
print: {
    .label m = 2
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
  msg1: .byte 'a', 'b', 'c', 'd'
  msg2: .byte '1', '2', '3', '4'
