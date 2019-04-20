// Tests optimizing derefs of *(ptr+b) to ptr[b]
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
    lda #<msg1
    sta print.m
    lda #>msg1
    sta print.m+1
    jsr print
    lda #<msg2
    sta print.m
    lda #>msg2
    sta print.m+1
    jsr print
    rts
}
// print(byte* zeropage(2) m)
print: {
    .label m = 2
    ldy #2
    lda (m),y
    sta SCREEN,x
    inx
    rts
}
  msg1: .byte 'a', 'b', 'c', 'd'
  msg2: .byte '1', '2', '3', '4'
