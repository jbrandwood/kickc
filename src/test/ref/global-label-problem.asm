// Demonstrates problems with local labels overwriting global labels
// This should produce "abca" - but produces "abcc" because the local variable containing "c" overrides the global variable containing "a"
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Screen pointer and index
  .label SCREEN = $400
main: {
    // print("a")
    ldx #0
    lda #<msg
    sta.z print.msg
    lda #>msg
    sta.z print.msg+1
    jsr print
    // print("b")
    lda #<msg1
    sta.z print.msg
    lda #>msg1
    sta.z print.msg+1
    jsr print
    // print1()
    jsr print1
    // }
    rts
    msg1: .text "b"
    .byte 0
}
print1: {
    // print("c")
    lda #<msg
    sta.z print.msg
    lda #>msg
    sta.z print.msg+1
    jsr print
    // print("a")
    lda #<@msg
    sta.z print.msg
    lda #>@msg
    sta.z print.msg+1
    jsr print
    // }
    rts
    msg: .text "c"
    .byte 0
}
// print(byte* zp(2) msg)
print: {
    .label msg = 2
  __b1:
    // while(*msg)
    ldy #0
    lda (msg),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[idx++] = *msg++
    ldy #0
    lda (msg),y
    sta SCREEN,x
    // SCREEN[idx++] = *msg++;
    inx
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    jmp __b1
}
  msg: .text "a"
  .byte 0
