// Tests optimizing derefs of *(ptr+b) to ptr[b - even when a noop-cast is needed
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label screen_idx = 4
main: {
    lda #0
    sta.z screen_idx
    lda #<msg1
    sta.z print.m
    lda #>msg1
    sta.z print.m+1
    jsr print
    lda #<msg2
    sta.z print.m
    lda #>msg2
    sta.z print.m+1
    jsr print
    rts
}
// print(byte* zeropage(2) m)
print: {
    .label m = 2
    lda.z screen_idx
    asl
    ldy #2
    tax
    lda (m),y
    sta SCREEN,x
    iny
    lda (m),y
    sta SCREEN+1,x
    inc.z screen_idx
    rts
}
  msg1: .byte 'a', 'b', 'c', 'd'
  msg2: .byte '1', '2', '3', '4'
