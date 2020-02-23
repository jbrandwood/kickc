// Tests optimizing derefs of *(ptr+b) to ptr[b]
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // print(msg1)
    ldx #0
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
    // SCREEN[idx++] = *(m+2)
    ldy #2
    lda (m),y
    sta SCREEN,x
    // SCREEN[idx++] = *(m+2);
    inx
    // }
    rts
}
  msg1: .byte 'a', 'b', 'c', 'd'
  msg2: .byte '1', '2', '3', '4'
